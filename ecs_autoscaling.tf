
#------------------
# Autoscaling CPU based
# Add 1 task with CPU Max > 85
# Remove 1 task with CPU Avg < 10
# -----------------

resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = var.desired_containers * 5
  min_capacity       = var.desired_containers
  resource_id        = "service/${aws_ecs_service.ecs_service_create.cluster}/${aws_ecs_service.ecs_service_create.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "scale_down_ecs_policy" {
  name               = "application-scale_down"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }
}


resource "aws_appautoscaling_policy" "scale_up_ecs_policy" {
  name               = "application-scale_up"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }
}


resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = "application-task_cpu_low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 3
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 10
  dimensions = {
    ClusterName = aws_ecs_service.ecs_service_create.cluster
    ServiceName = aws_ecs_service.ecs_service_create.name
  }
  alarm_actions = [aws_appautoscaling_policy.scale_down_ecs_policy.arn]
}



resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "application-task_cpu_high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 3
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Maximum"
  threshold           = 85
  dimensions = {
    ClusterName = aws_ecs_service.ecs_service_create.cluster
    ServiceName = aws_ecs_service.ecs_service_create.name
  }
  alarm_actions = [aws_appautoscaling_policy.scale_up_ecs_policy.arn]
}