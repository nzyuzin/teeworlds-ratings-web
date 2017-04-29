$(document).ready(function(){
  $('.ui.form')
  .form({
    fields: {
    	match: {
        identifier  : 'password2',
        rules: [
          {
            type   : 'match[password1]',
            prompt : 'Please enter the same password in both fields'
          }
        ],
        identifier  : 'email2',
        rules: [
          {
            type   : 'match[email1]',
            prompt : 'Please enter the same e-mail in both fields'
          }
        ]
      },
      username: {
        identifier: 'username',
        rules: [
          {
            type   : 'empty',
            prompt : 'Please enter an username'
          }
        ]
      },
      password: {
        identifier: 'password1',
        rules: [
          {
            type   : 'empty',
            prompt : 'Please enter a password'
          },
          {
            type   : 'minLength[6]',
            prompt : 'Your password must be at least {ruleValue} characters'
          }
        ]
      },
     email: {
        identifier: 'email1',
        rules: [
          {
            type   : 'email',
            prompt : 'Please enter a valid E-mail address'
          }
        ]
      },
    }
  })
;
});