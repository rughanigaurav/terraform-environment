resource "aws_cognito_user_pool" "test_pool" {

    name = var.userpool_name
    username_attributes = ["email"]
    auto_verified_attributes = ["email"]

    alias_attributes = [ "username", "email" ]

    mfa_configuration = "Optional"
    
    email_configuration {
      
        email_sending_account = "Send email with Cognito"
        from_email_address = "no-reply@verificationemal.com"
        reply_to_email_address = ""
            
    }

    username_configuration {
      case_sensitive = true

    }
    
    
    password_policy {
      
        minimum_length = 10
        require_lowercase = true
        require_uppercase = true
        require_numbers = true
        require_symbols = true
        temporary_password_validity_days = 7
        
    }    

    schema {
      name = "email"
      attribute_data_type = "String"
      required = true
      mutable = false
    }

    schema {
      name = "first_name"
      required = true
      attribute_data_type = "String"
      mutable = false
    }

    schema {
        name = "family_name"
        required = true
        attribute_data_type = "String"
        mutable = false
    }

    schema {
        name = "last_name"
        required = true
        attribute_data_type = "String"
        mutable = false
    }

    schema {
        name = "Phone_number"
        attribute_data_type = "Number"
        mutable = false
        required = true
    }

    schema {
        name = "custom:Role"
        attribute_data_type = "String"
        mutable = false
    }

    schema {
        name = "email_verified"
        attribute_data_type = "String"
        mutable = true

    }

    schema {
        name = "phone_number_verified"
        attribute_data_type = "Number"
        mutable = true
    }
}

resource "aws_cognito_user_pool_client" "staging" {

    name = var.client_name
    user_pool_id = aws_cognito_user_pool.test_pool.id
    generate_secret = false
    allowed_oauth_flows_user_pool_client = false
}