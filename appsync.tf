resource "aws_appsync_api_key" "hackfest_chat" {
  api_id  = aws_appsync_graphql_api.hackfest_chat.id
  expires = "2023-09-20T16:00:00Z"
}

resource "aws_appsync_graphql_api" "hackfest_chat" {
  additional_authentication_provider {
    authentication_type = "API_KEY"
  }
  authentication_type = "AMAZON_COGNITO_USER_POOLS"
  name                = "Hackfest Chat"
  schema              = file("api-schema.graphql")

  user_pool_config {
    aws_region     = var.aws_region
    default_action = "ALLOW"
    user_pool_id   = var.user_pool_id
  }
}

resource "aws_appsync_datasource" "conversations" {
  api_id      = aws_appsync_graphql_api.hackfest_chat.id
  description = "conversationsTable DynamoDB data source"
  dynamodb_config {
    table_name = var.dynamodb_table_names["conversations"]
  }
  name             = "conversationsTableDataSource"
  service_role_arn = var.appsync_service_role_arn
  type             = "AMAZON_DYNAMODB"
}

resource "aws_appsync_datasource" "messages" {
  api_id      = aws_appsync_graphql_api.hackfest_chat.id
  description = "messagesTable DynamoDB data source"
  dynamodb_config {
    table_name = var.dynamodb_table_names["messages"]
  }
  name             = "messagesTableDataSource"
  service_role_arn = var.appsync_service_role_arn
  type             = "AMAZON_DYNAMODB"
}

resource "aws_appsync_datasource" "user_conversations" {
  api_id      = aws_appsync_graphql_api.hackfest_chat.id
  description = "userConversationsTable DynamoDB data source"
  dynamodb_config {
    table_name = var.dynamodb_table_names["user_conversations"]
  }
  name             = "userConversationsTableDataSource"
  service_role_arn = var.appsync_service_role_arn
  type             = "AMAZON_DYNAMODB"
}

resource "aws_appsync_datasource" "users" {
  api_id      = aws_appsync_graphql_api.hackfest_chat.id
  description = "usersTable DynamoDB data source"
  dynamodb_config {
    table_name = var.dynamodb_table_names["users"]
  }
  name             = "usersTableDataSource"
  service_role_arn = var.appsync_service_role_arn
  type             = "AMAZON_DYNAMODB"
}
