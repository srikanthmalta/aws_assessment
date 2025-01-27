

resource "aws_route53_zone" "zone" {
  name = "terraform-test.org"  # as terraform-test.com is alredy in use
}

resource "aws_route53_record" "webserver_dns" {
  zone_id = aws_route53_zone.zone.zone_id
  name    = "terraform-test.com"
  type    = "A"
  ttl     = 300
  records = [aws_instance.public_instance.public_ip]
  depends_on = [  aws_instance.public_instance]
}
