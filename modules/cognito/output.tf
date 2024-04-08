output "user_pool_id" {

    value = aws_cognito_user_pool.test_pool.id

}

output "client_id" {
  
    value = aws_cognito_user_pool_client.staging.id

}