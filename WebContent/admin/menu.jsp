<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>CC 관리자 메뉴</title>
</head>
<body>
<form target="content" method="post" name="search_form" action="main.jsp">
	<input type="hidden" name="command">
</form>
<table>
	<tr>
		<td style="font-size: 20px; font-weight: bold;">파일 적용 및 수정</td>
	</tr>
	<tr height = 5px></tr>
	<tr>
		<td style="font-size: 15px; font-weight: bold;">정보 수정</td>
	</tr>
	<tr>
		<td>
			<a href="user.jsp" target="content">유저 정보 수정</a>
		</td>
	</tr>
	<tr>
		<td>
			<a href="user_roulette_reset.jsp" target="content">유저 룰렛 시간 리셋</a>
		</td>
	</tr>
	<tr>
		<td>
			<a href="user_attend_reset.jsp" target="content">유저 출석 시간 리셋</a>
		</td>
	</tr>
	<tr>
		<td>
			<a href="storyVersion.jsp" target="content">스토리 버전 수정</a>
		</td>
	</tr>
	<tr>
		<td>
			<a href="sendRentalBook.jsp" target="content">대여권 보내기</a>
		</td>
	</tr>
	<tr>
		<td>
			<a href="tutorial.jsp" target="content">튜토리얼 작품 수정</a>
		</td>
	</tr>
	<tr height = 5px></tr>
	<tr>
		<td style="font-size: 15px; font-weight: bold;">파일 업로드 (beta)</td>
	</tr>
	<tr>
		<td>
			<a href="storyupload.jsp" target="content">스토리 파일 업로드</a>
		</td>
	</tr>
	<tr height = 5px></tr>
	<tr>
		<td style="font-size: 15px; font-weight: bold;">csv 파일 적용</td>
	</tr>
	<tr>
		<td>
			<a href="csvupload_banner.jsp" target="content">배너 데이터 적용</a>
		</td>
	</tr>
	<tr>
		<td>
			<a href="csvupload_story.jsp" target="content">스토리 데이터 적용</a>
		</td>
	</tr>
	<tr>
		<td>
			<a href="csvupload_episode.jsp" target="content">에피소드 데이터 적용</a>
		</td>
	</tr>
	<tr>
		<td>
			<a href="csvupload_categorylist.jsp" target="content">카테고리 데이터 적용</a>
		</td>
	</tr>
	<tr>
		<td>
			<a href="csvupload_costumedata.jsp" target="content">코스튬 데이터 적용</a>
		</td>
	</tr>
	<tr>
		<td>
			<a href="csvupload_selectitem.jsp" target="content">선택지 데이터 적용</a>
		</td>
	</tr>
	<tr>
		<td>
			<a href="csvupload_shopitem.jsp" target="content">상점 데이터 적용</a>
		</td>
	</tr>
	<tr>
		<td>
			<a href="csvupload_attendevent.jsp" target="content">출석 보상 데이터 적용</a>
		</td>
	</tr>
	<tr>
		<td>
			<a href="csvupload_item.jsp" target="content">아이템 데이터 적용</a>
		</td>
	</tr>
	<tr height = 5px></tr>
	<tr>
		<td style="font-size: 15px; font-weight: bold;">에셋 번들 버전</td>
	</tr>
	<tr>
		<td>
			<a href="csvupload_assetbundleversion.jsp" target="content">에셋 번들 버전 적용</a>
		</td>
	</tr>
	<tr height = 15px></tr>
	<tr>
		<td style="font-size: 20px; font-weight: bold;">서비스 지표 데이터</td>
	</tr>
	<tr height = 5px></tr>
	<tr>
		<td style="font-size: 15px; font-weight: bold;">유저 기본 데이터 상세</td>
	</tr>
	<tr>
		<td>
			<a href="indicator_user_regist.jsp" target="content">가입자 수</a>
		</td>
	</tr>
	<tr>
		<td>
			<a href="indicator_user_login.jsp" target="content">로그인 수</a>
		</td>
	</tr>
	<tr>
		<td>
			<a href="indicator_user_listloadcount.jsp" target="content">실행 횟수</a>
		</td>
	</tr>
	<tr>
		<td>
			<a href="indicator_user_payer.jsp" target="content">유료 결제자 수</a>
		</td>
	</tr>
	<tr>
		<td>
			<a href="indicator_user_retention.jsp" target="content">2,7,30일자 리텐션</a>
		</td>
	</tr>
	<tr>
		<td>
			<a href="indicator_user_firstpayer.jsp" target="content">최초 유료 결제자 수</a>
		</td>
	</tr>
	<tr>
		<td>
			<a href="indicator_user_shopitem.jsp" target="content">상품별 구매 카운트</a>
		</td>
	</tr>
	<tr>
		<td>
			<a href="indicator_user_cash.jsp" target="content">유저 보유 재화 카운트</a>
		</td>
	</tr>
	<tr>
		<td>
			<a href="indicator_user_payerlist.jsp" target="content">결제 유저 목록</a>
		</td>
	</tr>
	<tr>
		<td>
			<a href="indicator_user_readfullrate.jsp" target="content">완독률</a>
		</td>
	</tr>
	<tr>
		<td>
			<a href="indicator_user_usegem.jsp" target="content">이야기별 패션 아이템 사용 젬 수</a>
		</td>
	</tr>
	<tr>
		<td>
			<a href="indicator_user_selectitem.jsp" target="content">이야기별 선택지 구매 횟수</a>
		</td>
	</tr>
	<tr>
		<td>
			<a href="indicator_user_roulettecount.jsp" target="content">룰렛 아이템별 획득 횟수</a>
		</td>
	</tr>
	<tr height = 5px></tr>
	<tr>
		<td style="font-size: 15px; font-weight: bold;">이야기 데이터 상세</td>
	</tr>
	<tr>
		<td>
			<a href="indicator_story_readcount.jsp" target="content">이야기별 읽은 수</a>
		</td>
	</tr>
	<tr>
		<td>
			<a href="indicator_story_itempercostume.jsp" target="content">패션상품별 아이템 구매 횟수</a>
		</td>
	</tr>
	<tr>
		<td>
			<a href="indicator_story_itemperstory.jsp" target="content">이야기별 패션 아이템 구매 횟수</a>
		</td>
	</tr>
	<tr height = 5px></tr>
	<tr>
		<td style="font-size: 15px; font-weight: bold;">메인 페이지 상세</td>
	</tr>
	<tr height = 5px></tr>
	<tr>
		<td style="font-size: 15px; font-weight: bold;">라이브 서비스</td>
	</tr>
	<tr>
		<td>
			<a href="question.jsp" target="content">문의 내역 보기</a>
		</td>
	</tr>
</table>
</body>
</html>