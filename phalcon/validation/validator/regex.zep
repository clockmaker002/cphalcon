
/*
 +------------------------------------------------------------------------+
 | Phalcon Framework                                                      |
 +------------------------------------------------------------------------+
 | Copyright (c) 2011-2013 Phalcon Team (http://www.phalconphp.com)       |
 +------------------------------------------------------------------------+
 | This source file is subject to the New BSD License that is bundled     |
 | with this package in the file docs/LICENSE.txt.                        |
 |                                                                        |
 | If you did not receive a copy of the license and are unable to         |
 | obtain it through the world-wide-web, please send an email             |
 | to license@phalconphp.com so we can send you a copy immediately.       |
 +------------------------------------------------------------------------+
 | Authors: Andres Gutierrez <andres@phalconphp.com>                      |
 |          Eduar Carvajal <eduar@phalconphp.com>                         |
 +------------------------------------------------------------------------+
 */

namespace Phalcon\Validation\Validator;

/**
 * Phalcon\Validation\Validator\Regex
 *
 * Allows validate if the value of a field matches a regular expression
 *
 *<code>
 *use Phalcon\Validation\Validator\Regex as RegexValidator;
 *
 *$validator->add('created_at', new RegexValidator(array(
 *   'pattern' => '/^[0-9]{4}[-\/](0[1-9]|1[12])[-\/](0[1-9]|[12][0-9]|3[01])$/',
 *   'message' => 'The creation date is invalid'
 *)));
 *</code>
 */
class Regex extends Phalcon\Validation\Validator implements Phalcon\Validation\ValidatorInterface
{

	/**
	 * Executes the validation
	 *
	 * @param  Phalcon\Validation validator
	 * @param  string attribute
	 * @return boolean
	 */
	public function validate(<Phalcon\Validation> validator, attribute) -> boolean
	{
		var matches, failed, message, value;

		/**
		 * Regular expression is set in the option 'pattern'
		 * Check if the value match using preg_match in the PHP userland
		 */
		let matches = null;
		let value = validator->getValue(attribute);
		if preg_match(this->getOption("pattern"), value, matches) {
			let failed = matches[0] != value;
		} else {
			let failed = true;
		}

		if failed === true {

			/**
			 * <comment>Check if the developer has defined a custom message</comment>
			 */
			let message = this->getOption("message");
			if !message {
				let message = "Value of field '" . attribute . "' doesn't match regular expression";
			}

			validator->appendMessage(new Phalcon\Validation\Message(message, attribute, "Regex"));
			return false;
		}

		return true;
	}

}
