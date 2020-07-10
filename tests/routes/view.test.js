/* global describe, beforeEach, afterEach, it, expect, jest */
const request = require('supertest')
const caseService = require('../../server/services/case-service')
const communityService = require('../../server/services/community-service')
const appSetup = require('../testUtils/appSetup')
const { authenticationMiddleware } = require('../testUtils/mockAuthentication')

let roles
// This needs mocking early, before 'requiring' jwt-decode
jest.doMock('jwt-decode', () => jest.fn(() => ({ authorities: roles })))

const createRouter = require('../../server/routes/index')

const defaults = require('../../server/routes/middleware/defaults')
const healthcheck = require('../../server/routes/middleware/healthcheck')

const viewRoute = createRouter({
  authenticationMiddleware
})

jest.mock('../../server/services/case-service')
jest.mock('../../server/services/community-service')

let app
let caseResponse = {}
let communityResponse = {}

describe('Routes', () => {
  jest.spyOn(healthcheck, 'health').mockImplementation(function (req, res, next) {
    return next()
  })

  jest.spyOn(defaults, 'defaults').mockImplementation(function (req, res, next) {
    req.params.courtCode = 'SHF'
    req.params.courtName = 'Sheffield Magistrates\' Court'
    return next()
  })

  jest.spyOn(caseService, 'getCaseList').mockImplementation(function () {
    return {
      cases: []
    }
  })

  jest.spyOn(caseService, 'getCase').mockImplementation(function () {
    return caseResponse
  })

  jest.spyOn(communityService, 'getPersonalDetails').mockImplementation(function () {
    return {}
  })

  jest.spyOn(communityService, 'getProbationRecord').mockImplementation(function () {
    return communityResponse
  })

  jest.spyOn(communityService, 'getProbationRecordWithRequirements').mockImplementation(function () {
    return communityResponse
  })

  jest.spyOn(communityService, 'getAttendanceDetails').mockImplementation(function () {
    return {
      attendances: []
    }
  })

  jest.spyOn(communityService, 'getBreachDetails').mockImplementation(function () {
    return {
      conviction: {}
    }
  })

  beforeEach(() => {
    app = require('../../app')
    app = appSetup(viewRoute)
  })

  afterEach(() => {
    jest.clearAllMocks()
    caseResponse = {}
  })

  it('default route should return status 302 as it should redirect to case list', () => {
    return request(app).get('/').then(response => {
      expect(response.statusCode).toEqual(302)
    })
  })

  it('case list route should redirect to corrected route', () => {
    return request(app).get('/cases').then(response => {
      expect(response.statusCode).toEqual(302)
      expect(healthcheck.health).not.toHaveBeenCalled()
    })
  })

  it('case list route should call the case service to fetch case list data', async () => {
    const response = await request(app).get('/cases/2020-01-01')
    expect(caseService.getCaseList).toHaveBeenCalledWith('SHF', '2020-01-01', expect.any(Array))
    return response
  })

  it('case list route should redirect when filtering case list', async () => {
    return request(app).post('/cases/2020-01-01', {}).then(response => {
      expect(response.statusCode).toEqual(302)
    })
  })

  it('case summary details route should call the case service to fetch case data', async () => {
    const response = await request(app).get('/case/8678951874/details')
    expect(caseService.getCase).toHaveBeenCalledWith('SHF', '8678951874')
    return response
  })

  it('case summary personal details route should call the case service to fetch case data and NOT call the community service if the defendant is not known to probation', async () => {
    caseResponse = {
      probationStatus: 'Not known',
      crn: ''
    }
    const response = await request(app).get('/case/8678951874/details')
    expect(caseService.getCase).toHaveBeenCalledWith('SHF', '8678951874')
    expect(communityService.getPersonalDetails).not.toHaveBeenCalled()
    return response
  })

  it('case summary details route should redirect when viewing all previous orders', async () => {
    return request(app).post('/case/8678951874/record', {}).then(response => {
      expect(response.statusCode).toEqual(302)
    })
  })

  it('case summary probation record route should call the case service to fetch case data', async () => {
    caseResponse = {
      probationStatus: 'Current',
      crn: 'D985513'
    }
    const response = await request(app).get('/case/8678951874/record')
    expect(caseService.getCase).toHaveBeenCalledWith('SHF', '8678951874')
    expect(communityService.getProbationRecordWithRequirements).toHaveBeenCalledWith('D985513')
    expect(communityService.getPersonalDetails).toHaveBeenCalledWith('D985513')
    return response
  })

  it('case summary attendance route should call the case service to fetch attendance data', async () => {
    caseResponse = {
      probationStatus: 'Current',
      crn: 'D985513'
    }
    communityResponse = {
      convictions: [{
        convictionId: 1403337513,
        active: true
      }]
    }
    const response = await request(app).get('/case/668911253/record/1403337513')
    expect(caseService.getCase).toHaveBeenCalledWith('SHF', '668911253')
    expect(communityService.getProbationRecordWithRequirements).toHaveBeenCalledWith('D985513')
    expect(communityService.getAttendanceDetails).toHaveBeenCalledWith('D985513', '1403337513')
    return response
  })

  it('case summary attendance route should NOT call the case service to fetch attendance data if the order is inactive', async () => {
    caseResponse = {
      probationStatus: 'Current',
      crn: 'D985513'
    }
    communityResponse = {
      convictions: [{
        convictionId: 1403337513,
        active: false
      }]
    }
    const response = await request(app).get('/case/668911253/record/1403337513')
    expect(caseService.getCase).toHaveBeenCalledWith('SHF', '668911253')
    expect(communityService.getProbationRecordWithRequirements).toHaveBeenCalledWith('D985513')
    expect(communityService.getAttendanceDetails).not.toHaveBeenCalled()
    return response
  })

  it('case summary breach details route should call the case service to fetch breach data', async () => {
    caseResponse = {
      probationStatus: 'Current',
      crn: 'D985513'
    }
    communityResponse = {
      convictions: [{
        convictionId: 1403337513,
        breaches: [
          {
            breachId: 12345,
            description: 'Community Order/SSO Breach',
            started: '2014-12-30',
            status: 'In progress'
          },
          {
            breachId: 54321,
            description: 'Community Order/SSO Breach',
            started: '2014-12-26',
            status: 'Breach Summons Issued'
          }
        ]
      }]
    }

    const response = await request(app).get('/case/668911253/record/1403337513/breach/12345')
    expect(caseService.getCase).toHaveBeenCalledWith('SHF', '668911253')
    expect(communityService.getProbationRecord).toHaveBeenCalledWith('D985513')
    expect(communityService.getBreachDetails).toHaveBeenCalledWith('D985513', '1403337513', '12345')
    return response
  })

  // @TODO: Implement tests when completing this section of work and delete this TODO
  it('case summary risk registers route should call the case service to fetch case data', async () => {
    const response = await request(app).get('/case/8678951874/risk')
    expect(caseService.getCase).toHaveBeenCalledWith('SHF', '8678951874')
    return response
  })
})
