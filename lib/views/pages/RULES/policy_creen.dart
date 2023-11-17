import 'package:flutter/material.dart';

class PolicyScreen extends StatefulWidget {
  const PolicyScreen({super.key});

  @override
  State<PolicyScreen> createState() => _PolicyScreenState();
}

class _PolicyScreenState extends State<PolicyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Thông Báo Bảo Mật')),
      ),
      body: const Column(children: [
        const SizedBox(
          height: 10,
        ),
        Text(
          '1.    Giới Thiệu',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
            '1.1 Chào mừng bạn đến với Tiktok.vn được được vận hành bởi Công ty cổ phần Giải trí và Thể thao điện tử Việt Nam và các công ty liên kết và các công ty liên quan với Tiktok (gọi riêng và gọi chung là, "Tiktok", "chúng tôi", hay "của chúng tôi"). TikTok nghiêm túc thực hiện trách nhiệm của mình liên quan đến bảo mật thông tin theo các quy định về bảo vệ bí mật thông tin cá nhân của pháp luật Việt Nam và cam kết tôn trọng quyền riêng tư và sự quan tâm của tất cả người dùng đối với Tiktok.vn của chúng tôi ("Trang Web") (chúng tôi gọi Trang Web và các dịch vụ chúng tôi cung cấp như mô tả trên Trang Web của chúng tôi là "Các Dịch Vụ"). Chúng tôi nhận biết tầm quan trọng của dữ liệu cá nhân mà bạn đã tin tưởng giao cho chúng tôi và tin rằng chúng tôi có trách nhiệm quản lý, bảo vệ và xử lý dữ liệu cá nhân của bạn một cách thích hợp. Thông báo Bảo mật này ("Thông báo Bảo mật" hay "Thông báo") được thiết kế để giúp bạn hiểu được cách thức chúng tôi thu thập, sử dụng, tiết lộ và/hoặc xử lý dữ liệu cá nhân mà bạn đã cung cấp cho chúng tôi và/hoặc lưu giữ về bạn, cho dù là hiện nay hoặc trong tương lai, cũng như để giúp bạn đưa ra quyết định sáng suốt trước khi cung cấp cho chúng tôi bất kỳ dữ liệu cá nhân nào của bạn. Thông báo Bảo mật này cũng được thiết kế để hỗ trợ Khách hàng của chúng tôi hiện đang sống tại Liên Minh Châu Âu (EU) hiểu được các quyền của họ đối với các dữ liệu cá nhân được quy định tại Quy định chung về bảo vệ dữ liệu của EU khi họ sử dụng Dịch vụ. Vui lòng đọc kỹ Thông báo Bảo mật này. Nếu bạn có bất kỳ thắc mắc nào về thông tin này hoặc các phương pháp bảo mật thông tin của chúng tôi, vui lòng xem mục "Hỏi Đáp, Thắc Mắc, Khiếu Nại và Liên Hệ" ở phần cuối của Thông báo Bảo mật này'),
        const SizedBox(
          height: 5,
        ),
        Text(
            '1.2 """Dữ Liệu Cá Nhân" hay "dữ liệu cá nhân" có nghĩa là dữ liệu, dù đúng hay không, về một cá nhân mà thông qua đó có thể được xác định được danh tính, hoặc từ dữ liệu đó và thông tin khác mà một tổ chức có hoặc có khả năng tiếp cận. Các ví dụ thường gặp về dữ liệu cá nhân có thể gồm có tên, số chứng minh nhân dân và thông tin liên hệ.'),
        const SizedBox(
          height: 5,
        ),
        Text(
            '1.3 Bằng việc sử dụng Các Dịch Vụ, đăng ký một tài khoản với chúng tôi, truy cập trang web của chúng tôi, hoặc tiếp cận Các Dịch Vụ, bạn xác nhận và đồng ý rằng bạn chấp nhận các phương pháp, yêu cầu, và/hoặc chính sách được mô tả trong Thông báo Bảo mật này, và theo đây bạn đồng ý cho phép chúng tôi thu thập, sử dụng, tiết lộ và/hoặc xử lý dữ liệu cá nhân của bạn như mô tả trong đây.'),
      ]),
    );
  }
}
