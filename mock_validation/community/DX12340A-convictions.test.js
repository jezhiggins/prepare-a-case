/* global beforeAll, describe, it */
const { getValidator } = require('../utils/validator')
const { testGeneralValidation } = require('../common')

const mapping = require('../../mappings/community/DX12340A-convictions.json')

describe('Validate convictions mock with CRN DX12340A', () => {
  let validator

  beforeAll(async () => {
    validator = await getValidator()
  })

  it('should validate against the swagger doc', () => {
    testGeneralValidation(validator, mapping)
  })
})
