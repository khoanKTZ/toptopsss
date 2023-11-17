import 'package:flutter/material.dart';

class RulesScreen extends StatefulWidget {
  const RulesScreen({Key? key}) : super(key: key);

  @override
  State<RulesScreen> createState() => _RulesScreenState();
}

class _RulesScreenState extends State<RulesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Điều Khoản dịch vụ'),
      ),
      body: const SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '1.    Giới Thiệu',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              '1.1. Chấp Nhận Điều Khoản',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              'BẰNG VIỆC SỬ DỤNG CÁC DỊCH VỤ HOẶC MỞ MỘT TÀI KHOẢN, BẠN CHO BIẾT RẰNG BẠN CHẤP NHẬN, KHÔNG RÚT LẠI, CÁC ĐIỀU KHOẢN DỊCH VỤ NÀY. NẾU BẠN KHÔNG ĐỒNG Ý VỚI CÁC ĐIỀU KHOẢN NÀY, VUI LÒNG KHÔNG SỬ DỤNG CÁC DỊCH VỤ CỦA CHÚNG TÔI HAY TRUY CẬP TRANG WEB. NẾU BẠN DƯỚI 18 TUỔI HOẶC "ĐỘ TUỔI TRƯỞNG THÀNH" PHÙ HỢP Ở NƠI BẠN SỐNG, BẠN PHẢI XIN PHÉP CHA MẸ HOẶC NGƯỜI GIÁM HỘ HỢP PHÁP ĐỂ MỞ MỘT TÀI KHOẢN VÀ CHA MẸ HOẶC NGƯỜI GIÁM HỘ HỢP PHÁP PHẢI ĐỒNG Ý VỚI CÁC ĐIỀU KHOẢN DỊCH VỤ NÀY. NẾU BẠN KHÔNG BIẾT BẠN CÓ THUỘC "ĐỘ TUỔI TRƯỞNG THÀNH" Ở NƠI BẠN SỐNG HAY KHÔNG, HOẶC KHÔNG HIỂU PHẦN NÀY, VUI LÒNG KHÔNG TẠO TÀI KHOẢN CHO ĐẾN KHI BẠN ĐÃ NHỜ CHA MẸ HOẶC NGƯỜI GIÁM HỘ HỢP PHÁP CỦA BẠN GIÚP ĐỠ. NẾU BẠN LÀ CHA MẸ HOẶC NGƯỜI GIÁM HỘ HỢP PHÁP CỦA MỘT TRẺ VỊ THÀNH NIÊN MUỐN TẠO MỘT TÀI KHOẢN, BẠN PHẢI CHẤP NHẬN CÁC ĐIỀU KHOẢN DỊCH VỤ NÀY THAY MẶT CHO TRẺ VỊ THÀNH NIÊN ĐÓ VÀ BẠN SẼ CHỊU TRÁCH NHIỆM ĐỐI VỚI TẤT CẢ HOẠT ĐỘNG SỬ DỤNG TÀI KHOẢN HAY CÁC DỊCH VỤ, BAO GỒM CÁC GIAO DỊCH MUA HÀNG DO TRẺ VỊ THÀNH NIÊN THỰC HIỆN, CHO DÙ TÀI KHOẢN CỦA TRẺ VỊ THÀNH NIÊN ĐÓ ĐƯỢC MỞ VÀO LÚC NÀY HAY ĐƯỢC TẠO SAU NÀY VÀ CHO DÙ TRẺ VỊ THÀNH NIÊN CÓ ĐƯỢC BẠN GIÁM SÁT TRONG GIAO DỊCH MUA HÀNG ĐÓ HAY KHÔNG',
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
                'TikTok có quyền chỉnh sửa các Điều Khoản Dịch Vụ này vào bất kỳ lúc nào mà không cần thông báo cho người dùng. Việc bạn tiếp tục sử dụng Các Dịch Vụ, Trang Web này, hoặc Tài Khoản của bạn sẽ được xem là sự chấp nhận, không rút lại đối vớicác điều khoản chỉnh sửa đó.'),
            SizedBox(height: 5),
            Text(
              '1.2. Trách Nhiệm Sử Dụng',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            Text(
              'Bạn đồng ý không sử dụng dịch vụ của chúng tôi cho bất kỳ mục đích bất hợp pháp hoặc gian lận.',
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
                'Tiktok   có quyền thay đổi, điều chỉnh, đình chỉ hoặc ngưng bất kỳ phần nào của Trang Web này hoặc Các Dịch Vụ vào bất kỳ lúc nào. Tiktok có thể ra mắt Các Dịch Vụ nhất định hoặc các tính năng của chúng trong một phiên bản beta, phiên bản này có thể không hoạt động chính xác hoặc theo cùng cách như phiên bản cuối cùng, và chúng tôi sẽ không chịu trách nhiệm pháp lý trong các trường hợp đó. Tiktok cũng có thể toàn quyền áp dụng giới hạn đối với các tính năng nhất định hoặc hạn chế quyền truy cập của bạn đối với một phần hoặc toàn bộ Trang Web hoặc Các Dịch Vụ mà không cần thông báo hoặc phải chịu trách nhiệm pháp lý'),
            const SizedBox(height: 10),
            Text(
              '2.    Bảo Mật',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 5,
            ),
            Text('2.1 Tiktok rất coi trọng việc bảo mật thông tin của bạn'),
            const SizedBox(
              height: 5,
            ),
            Text(
                'Để bảo vệ các quyền của bạn một cách hiệu quả hơn, chúng tôi đã cung cấp Chính Sách Bảo Mật tại Tiktok để giải thích chi tiết về các cách thức bảo mật thông tin của chúng tôi. Vui lòng xem Chính Sách Bảo Mật để hiểu được cách thức tiktok thu thập và sử dụng thông tin liên kết với Tài Khoản của bạn và/hoặc việc bạn sử dụng Các Dịch Vụ. Bằng việc sử dụng Các Dịch Vụ hoặc đồng ý với các Điều Khoản Dịch Vụ này, bạn đồng ý cho phép tiktok thu thập, sử dụng, tiết lộ và/hoặc xử lý Nội Dung và dữ liệu cá nhân của bạn như mô tả trong Chính Sách Bảo Mật này.'),
            const SizedBox(
              height: 5,
            ),
            Text(
                'Người dùng nào lưu giữ dữ liệu cá nhân của một người dùng khác ("Bên Nhận Thông Tin") phải (i) tuân thủ mọi điều luật bảo vệ dữ liệu cá nhân hiện hành; (ii) cho phép người dùng kia ("Bên Tiết Lộ Thông Tin") tự xóa tên mình ra khỏi cơ sở dữ liệu của Bên Nhận Thông Tin; và (iii) cho phép Bên Tiết Lộ Thông Tin xem các thông tin đã được Bên Nhận Thông Tin thu thập về họ.'),
            const SizedBox(height: 10),
            Text(
              '3.   GIỚI HẠN VỀ QUYỀN SỬ DỤNG',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
                'Tiktok cấp cho bạn quyền sử dụng có giới hạn để truy cập và sử dụng Các Dịch Vụ tuân theo các điều khoản và điều kiện của Điều Khoản Dịch Vụ này vì mục đích sử dụng cá nhân. Việc cấp quyền này không cho phép bạn sử dụng vì bất kỳ mục đích thương mại nào hay sử dụng vì mục đích phái sinh đối với Các Dịch Vụ này (bao gồm nhưng không giới hạn ở bất kỳ yếu tố riêng lẻ nào hay Nội Dung của nó). Tất cả Nội Dung, thương hiệu, nhãn hiệu dịch vụ, tên thương hiệu, logo và tài sản trí tuệ khác được hiển thị trên Trang Web là tài sản của tiktok và của các chủ sở hữu bên thứ ba được chỉ rõ trên Trang Web, nếu có. Bất kỳ đối tượng nào truy cập vào Trang Web đều không có quyền hoặc được cấp phép một cách trực tiếp hoặc gián tiếp sử dụng hoặc sao chép bất kỳ Nội dung, thương hiệu, nhãn hiệu dịch vụ, tên thương hiệu, logo hay bất kỳ tài sản trí tuệ nào khác và cũng không có đối tượng nào truy cập vào Trạng Web được yêu cầu bất kỳ quyền, quyền sở hữu hay quyền lợi nào liên quan đến các đối tượng trên. . Bằng việc sử dụng hoặc truy cập Các Dịch Vụ, bạn đồng ý tuân thủ các qui định pháp luật về sở hữu trí tuệ hiện hành đối với vấn đề bảo hộ bản quyền, thương hiệu, nhãn hiệu dịch vụ, Các Dịch Vụ, Trang Web và Nội Dung của nó. Bạn đồng ý không sao chép, phát tán, tái xuất bản, gửi, trưng bày công khai, trình diễn công khai, điều chỉnh, sửa đổi, cho thuê, bán, hay tạo phó bản của bất kỳ phần nào của Các Dịch Vụ, Trang Web hoặc Nội Dung của nó., Nếu không có sự đồng ý trước bằng văn bản của chúng tôi, Bạn cũng không được nhân bản hoặc chỉnh sửa một phần hay toàn bộ nội dung của Trang Web này trên máy chủ khác hoặc như một phần của bất kỳ trang web nào khác. Ngoài ra, bạn đồng ý rằng bạn sẽ không sử dụng bất kỳ công cụ robot, spider hay bất kỳ thiết bị tự động hay quy trình thủ công nào khác để theo dõi hay sao chép Nội Dung của chúng tôi, nếu không có sự đồng ý trước bằng văn bản của chúng tôi (thỏa thuận này áp dụng cho các công cụ tìm kiếm cơ bản trên các webside kết nối người dùng trực tiếp đến website đó). '),
            const SizedBox(
              height: 5,
            ),
            Text(
                'Nếu bạn có bất kỳ thắc mắc hay quay nại nào về các Điều Khoản Dịch Vụ này hoặc bất kỳ vấn đề nào được nêu ra trong các Điều Khoản Dịch Vụ này hoặc trên Trang Web, vui lòng liên hệ với chúng tôi tại:'),
            const SizedBox(
              height: 1,
            ),
            Text(
              'khuongkhoan10@gmail.com',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Divider(
              // Sử dụng Divider để tạo đường kẻ
              color: Colors.black, // Màu của đường kẻ
              thickness: 1, // Độ dày của đường kẻ
              indent: 20, // Khoảng cách từ bên trái đến đường kẻ
              endIndent: 20, // Khoảng cách từ bên phải đến đường kẻ
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
                'TÔI ĐÃ ĐỌC THỎA THUẬN NÀY VÀ ĐỒNG Ý VỚI TẤT CẢ CÁC QUY ĐỊNH CÓ TRONG NỘI DUNG BÊN TRÊN VÀ BẤT KỲ BẢN CHỈNH SỬA NÀO CỦA NỘI DUNG BÊN TRÊN SAU NÀY. BẰNG VIỆC NHẤP VÀO NÚT "ĐĂNG KÝ NGAY" HOẶC BẤT KỲ THAO TÁC NÀO TƯƠNG TỰ BÊN DƯỚI, TÔI HIỂU RẰNG TÔI ĐANG TẠO RA MỘT CHỮ KÝ ĐIỆN TỬ MÀ TÔI HIỂU RẰNG NÓ CÓ GIÁ TRỊ VÀ HIỆU LỰC TƯƠNG TỰ NHƯ CHỮ KÝ TÔI KÝ BẰNG TAY.'),
            const SizedBox(
              height: 5,
            ),
            Text('Cập nhật gần nhất: 17/11/2023')
          ],
        ),
      ),
    );
  }
}
