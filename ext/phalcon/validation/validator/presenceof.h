
extern zend_class_entry *phalcon_validation_validator_presenceof_ce;

ZEPHIR_INIT_CLASS(Phalcon_Validation_Validator_PresenceOf);

PHP_METHOD(Phalcon_Validation_Validator_PresenceOf, validate);

ZEND_BEGIN_ARG_INFO_EX(arginfo_phalcon_validation_validator_presenceof_validate, 0, 0, 2)
	ZEND_ARG_INFO(0, validator)
	ZEND_ARG_INFO(0, attribute)
ZEND_END_ARG_INFO()

ZEPHIR_INIT_FUNCS(phalcon_validation_validator_presenceof_method_entry) {
	PHP_ME(Phalcon_Validation_Validator_PresenceOf, validate, arginfo_phalcon_validation_validator_presenceof_validate, ZEND_ACC_PUBLIC)
	PHP_FE_END
};
