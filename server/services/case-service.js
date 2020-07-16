const { request } = require('./utils/request')
const config = require('../../config')
const apiUrl = config.apis.courtCaseService.url

const getCaseList = async (courtCode, date, filters, subsection) => {
  const res = await request(`${apiUrl}/court/${courtCode}/cases?date=${date}`)
  const allCases = []
  const addedCases = []
  const removedCases = []
  if (res.data.cases) {
    res.data.cases.forEach($case => {
      if ($case.createdToday) {
        allCases.push($case)
        addedCases.push($case)
      } else if ($case.removed) {
        removedCases.push($case)
      } else {
        allCases.push($case)
      }
    })
  }

  let filteredCases = subsection === 'added' ? addedCases : subsection === 'removed' ? removedCases : allCases

  function applyFilter (filterObj) {
    filteredCases = filteredCases.filter(courtCase => {
      let notFiltered = true
      let matched = false
      filterObj.items.forEach(item => {
        if (item.checked) {
          notFiltered = false
          matched = matched || courtCase[filterObj.id].toString() === item.value.toString()
        }
      })
      return notFiltered || matched
    })
  }

  if (filters && filteredCases) {
    filters.forEach(filterObj => {
      applyFilter(filterObj)
    })
  }

  return {
    ...res.data,
    totalCount: allCases.length,
    addedCount: addedCases.length,
    removedCount: removedCases.length,
    cases: filteredCases
  }
}

const getCase = async (courtCode, caseNo) => {
  const res = await request(`${apiUrl}/court/${courtCode}/case/${caseNo}`)
  return res.data
}

module.exports = {
  getCaseList,
  getCase
}
