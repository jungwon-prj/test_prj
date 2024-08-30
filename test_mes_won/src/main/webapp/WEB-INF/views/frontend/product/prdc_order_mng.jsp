<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.inssuf.won.util.*"%>
<%
// jsp properties
String thema = SessionUtil.getProperties("mes.thema");
String pageTitle = SessionUtil.getProperties("mes.company");
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<title><%=pageTitle%></title>
	<!-- Tell the browser to be responsive to screen width -->
	<meta
		content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no"
		name="viewport">
	<jsp:include page="/common/header_inc" flush="true">
		<jsp:param name="page_title" value="0" />
	</jsp:include>
</head>

<body class="hold-transition skin-<%=thema%> sidebar-mini" id="body">
	<!-- wrapper -->
	<div class="wrapper">
		<jsp:include page="/common/top_menu_inc" flush="true">
			<jsp:param name="fb_div" value="F" />
			<jsp:param name="page_title" value="0" />
		</jsp:include>

		<jsp:include page="/common/sidebar_menu_inc" flush="true">
			<jsp:param name="menu_div" value="F" />
			<jsp:param name="selected_menu_p_cd" value="1015" />
			<jsp:param name="selected_menu_cd" value="1024" />
		</jsp:include>

		<div class="content-wrapper">
			<section class="content-header">
				<h1><i class="fa-solid fa-box-archive"></i> 생산지시관리 </h1>
			</section>

			<section class="content">
				<!-- 칼럼1 -->
				<div class="col-sm-8">
					<div class="box-header">
						<h3 class="box-title">수주 현황</h3>	
						<div class="box-tools pull-right">
							<button type="button" id="" class="normal_btn" onclick="auto_cnt_update();">생산자동편성</button>
							<button type="button" id="btn_exdown" class="excel_btn" onclick="excelFileDownload();">
								<img class="excel_btn_img" src="/res/images/common/excel.svg">엑셀 다운로드
							</button>
							<button type="button" id="" class="del_btn" onclick="delete_ord_dtl_info();">초기화</button>
							<button type="button" id="btn_select" class="normal_btn" onclick="loadList();"> 조회 </button>
						</div>
					</div>
					
					<div class="box-body">
						<div class="row inputbox_wrap">
						
							<div class="col-sm-2">
								<label>납품요청일</label>
								<div class="dp_table">
									<input type="text" class="form-control pull-right" id="srch_dlv_req_dt" name="srch_dlv_req_dt" onkeypress="if(event.keyCode==13) {loadList('srch'); return false;}"/>
									<div class="input-group-addon">
										<i class="fa-regular fa-calendar" id="calendar_img" onclick="fnLoadCommonOption();"></i>
									</div>
								</div>
							</div>
							
							<div class="col-sm-2">								
								<label>수주번호</label>
								<input class="form-control" type="text" id="order_no" placeholder="수주번호"/>
							</div>
							
							<div class="col-sm-2 dropdown_box">
								<label>진행상태</label>
								<select id="srch_ord_status" class="form-control select2" onchange="loadList();">
						 			<option value="">전체</option>
						 			<option value="o1">대기</option>
						 			<option value="o2">생산진행중</option>
						 			<option value="o3">생산완료</option>
								</select>
							</div>
							
							
							<div class="col-sm-2">
								 <label>고객사</label>
								 <input type="text" class="form-control" id="srch_customer_nm"  placeholder="고객사">
							</div>
							
							<div class="col-sm-2">
								 <label>번호</label>
								 <input type="text" class="form-control" id="srch_item_code"  placeholder="번호">
							</div>
							
							<div class="col-sm-2">
								 <label>이름</label>
								 <input type="text" class="form-control" id="srch_item_nm"  placeholder="이름">
							</div>
													
						</div>
				   </div>
				   
					<!-- 그리드  -->
					<div  class="row">
						<div id="grid_list" style="width: 100%; height: 642px;"></div>
					</div>
				</div>
				
				
				<!--  칼럼2 -->
				<div class="col-sm-4">
					<div class="box-header">
						<h3 class="box-title">편성</h3>
						<div class="box-tools pull-right">
							<button type="button" id="btn_create_draw" class="normal_btn" onclick="tag();">QR코드발행</button>
							<button type="button" id="btn_create_draw" class="normal_btn" onclick="insertOrder();">구매발주등록</button>
							<button type="button" id="btn_create_draw" class="normal_btn" onclick="insert();">생산편성등록</button>
							<button type="button" id="btn_delete_draw" class="del_btn" onclick="delete_organization();">삭제</button>
						</div>
					</div>
					<div class="box-body">
					<div class="box-tools ">
						<label class="pull-left">재고수량 : </label><input type="text" readonly id="stk_cnt" style="border:none; width: 63px;">
						<label>수주수량 : </label><input type="text" readonly id="ord_cnt" style="border:none; width: 50px;">
						
						<button type="button" id="btn_update_draw" class="normal_btn pull-right" onclick="update();">생산편성수량등록</button>
						<br>
						<label class="pull-left">재고출하량 : </label><input type=text readonly id="stk_pln_cnt" style="border:none; width: 50px;">
						<label>생산편성대상수량 :</label><input type="text" readonly id="prod_pln_cnt" style="border:none; width: 50px; ">
<!-- 						<label id="cnt_div"><a id="def" href="#" data-toggle="popover" title="생산편성대상수량" data-content="retrun asde()"> -->
<!-- 						생산편성대상수량 : </a></label><input type="number" readonly id="prod_pln_cnt" style="border:none; width: 50px; "><span class="badge" style="background-color : red">5</span> -->
				  		<span class="badge" style="background-color : red ;display : none" id="popover_btn">0</span>
				  		<div id="popover_area" ></div>
<!-- 				  		<div class="progress-bar progress-bar-striped active" id="row_stat" role="progressbar" aria-valuenow="7" aria-valuemin="0" aria-valuemax="100" style="width:1%">70%</div> -->
				  	</div>
				  	</div>

					<!-- 그리드  -->
					<div  class="row">
						<div id="grid_list2" style="width: 100%; height: 710px;"></div>
					</div>
				</div>
					
			</section>
			<!-- /.content -->
		</div>

		
		<jsp:include page="/common/footer_inc" flush="true">
			<jsp:param name="page_title" value="0" />
		</jsp:include>
	</div>
	<!-- ./wrapper -->		
<!-- 구매발주등록 모달 -->
<div class="modal fade" id="insertModal" tabindex="-1" role="dialog" aria-labelledby="regModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
    <div class="modal-dialog" role="document" style="width: 70%;">
        <div class="modal-content" >

            <div class="modal-header">
                <h4 class="popup_title_ad"> </h4>
            </div>

         	<div class="modal-body">
         		
            	<div class="container-fluid">
            		<div class="col-md-12 text-right" style="margin-bottom: 1.5rem">
	         			<button type="button" class="normal_btn" onclick="purch_update();">요청수량입력</button>
	                	<button type="button" class="del_btn" onclick="purch_delete();">삭제</button>
	                	<br>
	                	
	<!--                     <button type="button" class="normal_btn" onclick="save_mat();">구매발주등록</button> -->
	<!--                     <button type="button" class="sub_btn" data-dismiss="modal">취소</button> -->
	                </div>
                	<form id="frm_reg" name="frm_reg" class="form-horizontal">
                	
	                	<div  class="row">
							<div id="grid_list3" style="width: 100%; height: 500px;"></div>
						</div>
	                    
					</form>
            	</div>
            </div>

            <div class="modal-footer">
                <div class="col-md-12 text-center">
<!--                 	<button type="button" class="del_btn" onclick="purch_delete();">삭제</button> -->
<!--                 	<button type="button" class="normal_btn" onclick="purch_update();">수정</button> -->
                    <button type="button" class="normal_btn" onclick="save_mat();">구매발주등록</button>
                    <button type="button" class="sub_btn" data-dismiss="modal">취소</button>
                </div>
            </div>
            

        </div>
    </div>
</div>
<!-- 구매발주 록 모달 -->
<!-- QR코드발행 모달 -->
<div class="modal fade" id="inModal" role="dialog" aria-labelledby="regModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
    <div class="modal-dialog" role="document">
        <div class="modal-content">

            <div class="modal-header">
                <h4 class="popup_title_ad"> </h4>
            </div>

         	<div class="modal-body">
            	<div class="container-fluid">
                	<form id="frm_reg" name="frm_reg" class="form-horizontal">
                		
	                    <div class="row">
                            <label class="col-sm-3">수주번호</label>
                            <div class="col-sm-9">
                                <input type="text" id="tag_order_no" class="form-control" placeholder="수주번호" />
                            </div>
	                    </div>
	                    
	                    <div class="row">
                            <label class="col-sm-3">이름</label>
                            <div class="col-sm-9">
                                <input type="text" id="tag_item_nm" class="form-control" placeholder="이름" />
                            </div>
	                    </div>
	       
	                    <div class="row">
                            <label class="col-sm-3">번호</label>
                            <div class="col-sm-9">
                                <input type="text" id="tag_item_code" class="form-control" placeholder="번호" />
                            </div>
	                    </div>
	                    
	                    <div class="row" hidden>
                            <label class="col-sm-3">item_key</label>
                            <div class="col-sm-9">
                                <input type="text" id="tag_item_key" class="form-control" placeholder="item_key" />
                            </div>
	                    </div>
	                    
	                    <div class="row">
                            <label class="col-sm-3">작업지시번호 </label>
                            <div class="col-sm-9">
                                <input type="text" id="tag_prod_key" class="form-control" placeholder="작업지시번호" />
                            </div>
	                    </div>
	                    
	                    <!-- qr 위치 -->
	                    <div class="row graph_area" id="qrcode" style="padding: 76px 100px 0px 182px;">
	                    <label id="sernr_qr">시리얼 번호</label>
	                    </div>
                    	<div class="row graph_area" id="qrcode_all" style="padding: 76px 100px 0px 182px; display:none;"></div>
						<div id="qrsernr" style="margin-left:20px; margin-right:20px;"></div>
					</form>
            	</div>
            </div>
            
            <div class="modal-footer">
                <div class="col-md-12 text-center">
                	<button type="button" class="normal_btn" onclick="tag_prod_key_num_load('before')">이전tag</button>
                	<button type="button" class="normal_btn" onclick="tag_prod_key_num_load('next')">다음tag</button>
                </div>
            </div>

            <div class="modal-footer">
                <div class="col-md-12 text-center">
                	<button type="button" class="normal_btn" onclick="print_qr('qrcode_all');">일괄출력</button>
                    <button type="button" class="normal_btn" onclick="print_qr('qrcode')">출력</button>
                    <button type="button" class="sub_btn" data-dismiss="modal">닫기</button>
                </div>
            </div>
            

        </div>
    </div>
</div>
<!-- 자재 등록 모달 -->



<!-- 구매발주 수정 모달 -->
<div class="modal fade" id="updateModal" tabindex="-1" role="dialog" aria-labelledby="regModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
    <div class="modal-dialog" role="document">
        <div class="modal-content">

            <div class="modal-header">
                <h4 class="popup_title_ad"> </h4>
            </div>

			<div class="modal-body">
				<form id="frm_reg" name="frm_reg" class="form-horizontal">
				
         	<div class="row">
            	<label class="col-sm-3">거래처명</label>
                   <div class="col-sm-9">
                       <input type="text" id="update_account_nm" onclick="auto_key(this.id)" class="form-control" placeholder="거래처명" />
                   </div>
            </div>
            
            <div class="row" hidden>
            	<label class="col-sm-3">거래처코드</label>
                   <div class="col-sm-9">
                       <input type="text" id="update_account_code" onclick="auto_key(this.id)" class="form-control" placeholder="거래처코드" />
                   </div>
            </div>
            
            <div class="row" hidden>
            	<label class="col-sm-3">account_key</label>
                   <div class="col-sm-9">
                       <input type="text" id="update_account_key" class="form-control" placeholder="거래처코드" />
                   </div>
            </div>
            
            <div class="row" hidden>
            	<label class="col-sm-3">item_key</label>
                   <div class="col-sm-9">
                       <input type="text" id="update_item_key" class="form-control" placeholder="자재코드" readonly />
                   </div>
            </div>
            
            <div class="row">
            	<label class="col-sm-3">자재코드</label>
                   <div class="col-sm-9">
                       <input type="text" id="update_item_code" class="form-control" placeholder="자재코드" readonly />
                   </div>
            </div>
            
            <div class="row">
            	<label class="col-sm-3">자재명</label>
                   <div class="col-sm-9">
                       <input type="text" id="update_item_nm" class="form-control" placeholder="이름" readonly />
                   </div>
            </div>
            
            <div class="row">
            	<label class="col-sm-3">재고수량</label>
                   <div class="col-sm-9">
                       <input type="number" id="update_stk_cnt" class="form-control" placeholder="재고수량" readonly/>
                   </div>
            </div>
            
            <div class="row">
            	<label class="col-sm-3">요청수량</label>
                   <div class="col-sm-9">
                       <input type="number" id="update_prc_cnt" onchange="numbercheck(this)" class="form-control" placeholder="요청수량" />
                   </div>
            </div>
            
            <div class="row">
            	<label class="col-sm-3">단가</label>
                   <div class="col-sm-9">
                       <input type="text" id="update_price" oninput="this.value = this.value.replace(/[^0-9.]/g, '')" onchange="numbercheck(this)" class="form-control" placeholder="단가" />
                   </div>
            </div>
            
            <div class="row">
				<label class="col-sm-3">납품요청일자</label>
				<div class="col-sm-9">
					<div class="input-group dp_table">  	
						<input type="text" class="form-control" id="update_dlv_req_dt" name="update_dlv_req_dt" placeholder="YYYY-MM-DD" >
						<div class="input-group-addon">
							<i class="fa-regular fa-calendar" id="modal_calendar_img"></i>
						</div>
					</div>
           		</div>
           	</div>
            
            <div class="row">
            	<label class="col-sm-3">비고</label>
                   <div class="col-sm-9">
                       <input type="text" id="update_memo" class="form-control" placeholder="비고" />
                   </div>
            </div>
            
            	</form>
			</div>

            <div class="modal-footer">
                <div class="col-md-12 text-center">
                	<button type="button" class="normal_btn" onclick="purch_saveBtn();">입력</button>
                    <button type="button" class="sub_btn" data-dismiss="modal">취소</button>
                </div>
            </div>

        </div>
    </div>
</div>
<!-- 구매발주 수정 모달 -->

<!-- 등록 모달 -->
<div class="modal fade2" id="insertModal2" tabindex="-1" role="dialog" aria-labelledby="regModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog modal-qr" role="document">
		<div class="modal-content">

			<div class="modal-header">
				<h4 class="popup_title_ad"> </h4>
			</div>

			<div class="modal-body">
            	<div class="container-fluid">
	                <form id="frm_reg" name="frm_reg" class="form-horizontal">
						
						<div id="create_date" class="row">								
							<label class="col-sm-3 popup_txt">생산요청일자</label>
							<div class="col-sm-9">
								<div class="input-group dp_table">
									<input class="form-control" type="text" id="prod_req_dt" name="prod_req_dt"/>
									<div class="input-group-addon">  		
										<i class="fa-regular fa-calendar" id="m_calendar_img"></i> 	
									</div>
								</div>
							</div>
						</div>
															                
	                    <div class="row">
		                    <label class="col-sm-3">지시생산량</label>
		                    <div class="col-sm-9">
		                        <input type="text" id="prod_cnt" name="prod_cnt" oninput="this.value = this.value.replace(/[^0-9.]/g, '')" onchange="numbercheck(this)" class="form-control" placeholder="지시생산량" />
		                    </div>
	                    </div>
	                    
					</form>
            	</div>
            </div>
            
              <div class="modal-footer">
                <div class="col-md-12 text-center">
                    <button type="button" class="normal_btn" onclick="save_organization();">저장</button>
                    <button type="button" class="sub_btn" data-dismiss="modal">취소</button>
                </div>
            </div>
           
		</div>
	</div>
</div>

<!-- 수정 모달 -->
<div class="modal fade2" id="inModal2" tabindex="-1" role="dialog" aria-labelledby="regModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog modal-qr" role="document" style="width: 300px;">
		<div class="modal-content" >

			<div class="modal-header">
				<h4 class="popup_title_ad"> </h4>
			</div>

			<div class="modal-body">
            	<div class="container-fluid">
	                <form id="frm_reg" name="frm_reg" class="form-horizontal">
	                
	                    <div class="row">
		                    <label class="col-sm-5">재고수량</label>
		                    <div class="col-sm-3">
		                        <input type="text" readonly id="m_stk_cnt" class="form-control" style="border:0 solid black"/>
		                    </div>
	                    </div>
	       
	                    <div class="row">
		                    <label class="col-sm-5">수주수량</label>
		                    <div class="col-sm-3">
		                        <input type="text" readonly id="m_ord_cnt" class="form-control" style="border:0 solid black"/>
		                    </div>
	                    </div>
	                    
	                    <div class="row">
		                    <label class="col-sm-5">생산편성대상수량</label>
		                    <div class="col-sm-3">
		                        <input type="text" readonly id="m_prod_pln_cnt" class="form-control" style="border:0 solid black"/>
		                    </div>
	                    </div>	   
	                                     
	                    <div class="row">
		                    <label class="col-sm-5">재고출하량</label>
		                    <div class="col-sm-5">
		                        <input type="number" id="m_stk_pln_cnt" class="form-control" placeholder="재고출하량" />
		                    </div>
	                    </div>
	                    	                    
					</form>
            	</div>
            </div>
            
              <div class="modal-footer">
                <div class="col-md-12 text-center">
                    <button type="button" class="normal_btn" onclick="cnt_update();">저장</button>
                    <button type="button" class="sub_btn" data-dismiss="modal">취소</button>
                </div>
            </div>
           
		</div>
	</div>
</div>

<div class="modal fade" id="autoInsertModal" tabindex="-1" role="dialog" aria-labelledby="regModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog modal-qr" role="document">
		<div class="modal-content">

			<div class="modal-header">
				<h4 class="popup_title_ad">생산자동편성</h4>
			</div>

			<div class="modal-body">
            	<div class="container-fluid">
	                <form id="frm_reg" name="frm_reg" class="form-horizontal">
						
						<div id="create_date" class="row">								
							<label class="col-sm-3 popup_txt">생산요청일자</label>
							<div class="col-sm-9">
								<div class="input-group dp_table">
									<input class="form-control" type="text" id="m_prod_req_dt" name="m_prod_req_dt" onkeypress="if(event.keyCode==13) {return false; return false;}"/>
									<div class="input-group-addon">  		
										<i class="fa-regular fa-calendar" id="m_calendar_img2"></i> 	
									</div>
								</div>
							</div>
						</div>
					</form>
            	</div>
            </div>
            
              <div class="modal-footer">
                <div class="col-md-12 text-center">
                    <button type="button" class="normal_btn" onclick="auto_save_organization();">저장</button>
                    <button type="button" class="sub_btn" data-dismiss="modal">취소</button>
                </div>
            </div>
           
		</div>
	</div>
</div>
	
<!-- 해당 화면에 대한 함수 -->
<script type="text/javascript" src="/res/design/designJS/qrcode.js"></script>
<script type="text/javascript" src="/res/design/designJS/qrcode.min.js"></script>
<script type="text/javascript">

/**
 * 
 */
status = '';
memberNo = '';
let chknum=1;
let tagDataLength;

let isloading = false;

var rec_length = 0;

let fault_cnt = 0;


let prod_sum = 0; //행의 생산지시 총 수량

	const auto_key = ( target ) => {
		$("#"+target).focus().trigger($.Event("keydown", {keyCode: 40}));
	}
	
	const numbercheck = ( target ) => {
		if(target.value <= 0) {
			fnMessageModalAlert("알림", "0이하의 숫자는 입력 하실 수 없습니다");
			$("#"+target.id).val(1);
		}
	}


	$(document).ready(function () {
		fnLoadCommonOption();
		grid_list_init();
		grid_list_init2();
		select_customer_list();
		item_code_item_nm_list();
		account_combo();
		
		loadList();
		
		$("#modal_calendar_img").click(function(){
			$('#update_dlv_req_dt').trigger("click");
		});
		
		$("#insertModal").on("shown.bs.modal", function(){
			grid_list_init3();
		});
		
		// 등록팝업 account_nm 입력시 account_key 자동입력
		$("#update_account_nm").change(function(){
			auto_account_key_code();
		});
		
		// 등록팝업 account_key 입력시 account_nm 자동입력
		$("#update_account_code").change(function(){
			auto_account_key_nm();
		});
		
//		$('[data-toggle="popover"]').popover();  

		$(function(){
			$('#popover_btn').popover({
		        animation: true,
		        container: "#popover_area",
		        html: false,
		        selector: false,
		        template: '<div class="popover" role="tooltip"><div class="arrow"></div><h3 class="popover-title"></h3><div class="popover-content"></div></div>',
				title: '생산편성수량',
				content: '',
				trigger:'hover'
			})
		})
		$('#popover_btn').on("mouseover",()=>{
			let totcnt = Number($("#prod_pln_cnt").val());
			console.log(fault_cnt)
			setTimeout(()=>{
				$(".popover-content").html('기존편성수량 : '+ (totcnt - fault_cnt) +' <br>불량갯수 : '+fault_cnt + '<br>편성대상수량 : ' + totcnt );
			},10)
			
		})
		
		//------------------------------------------------------------------------------------------------------
		// 등록 & 수정 화면 account_key 불러오기
		function auto_account_key_code() {
			var account_nm = $("#update_account_nm").val();
			var page_url = "/product/auto_account_key_code";
			var post_data = {'account_nm' : account_nm}
					
			$.ajax({
				url : page_url,
				data : post_data,
				type : 'POST',
				dataType : 'json',
				success : function(data) {
					if(data.resultMap.length>0) {
						$("#update_account_key").val(data.resultMap[0].account_key);
						$("#update_account_code").val(data.resultMap[0].account_code);
					}else{
						$("#update_account_key").val('');
						$("#update_account_nm").val('');
						$("#update_account_code").val('');
					}
				},
				error : function(jqXHR, textStatus, errorThrown) {
					fnMessageModalAlert("결과", "저장중 에러가 발생하였습니다.");
				}
			});
		}
	
		
		
		
		//------------------------------------------------------------------------------------------------------
		// 등록 & 수정 화면 account_nm 불러오기
		function auto_account_key_nm() {
			var account_code = $("#update_account_code").val();
			var page_url = "/product/auto_account_key_nm";
			var post_data = {'account_code' : account_code}
					
			$.ajax({
				url : page_url,
				data : post_data,
				type : 'POST',
				dataType : 'json',
				success : function(data) {
					console.log(data)
					if(data.resultMap.length>0) {
						$("#update_account_key").val(data.resultMap[0].account_key);
						$("#update_account_nm").val(data.resultMap[0].account_nm);
					}else{
						$("#update_account_key").val('');
						$("#update_account_nm").val('');
						$("#update_account_code").val('');
					}
				},
				error : function(jqXHR, textStatus, errorThrown) {
					fnMessageModalAlert("결과", "저장중 에러가 발생하였습니다.");
				}
			});
		}
		
		
		
		//------------------------------------------------------------------------------------------------------
		// 거래처명 거래처코드 자동완성
		function account_combo(){
			var startValue_combo_m = "";
			var	comboValue_nm_m = new Array;
			var	comboValue_nm_m2 = new Array;
			var page_url = "/purch_material/account_combo";
			$.ajax({
				url : page_url,
				type : 'POST',
				dataType : 'json',
				success : function(data) {
					if (data.status == 200 && (data.rows).length > 0) {
						constructArr = data.rows;
						
						// 가나다순 정렬
						constructArr = constructArr.sort((a, b) => a.account_nm.toLowerCase() < b.account_nm.toLowerCase() ? -1 : 1);
						
						$.each(constructArr, function(idx, row) {
							row.recid = idx + 1;
							if(row.account_nm)comboValue_nm_m.push(row.account_nm);
							if(row.account_code)comboValue_nm_m2.push(row.account_code);
						});
						if (startValue_combo_m == "") {
							$('#update_account_nm').w2field('combo', {  items: _.uniq(comboValue_nm_m,false) ,match : 'contains'});
							$('#update_account_code').w2field('combo', {  items: _.uniq(comboValue_nm_m2,false) ,match : 'contains'});
						}
					}
				},
				complete : function() {
					startValue_combo_m = ":)";
				}
			});
		}
		
		// srch 고객사명 자동완성
		function select_customer_list() {
			var page_url = "/product/select_customer_list";
			 
			var startValue_combo_m = "";
			var comboValue_nm_m = [];
			
			$.ajax({
				url : page_url
				, type : "POST"
				, dataType : "JSON"
				, success : function(data) {
					if(data.status == "200" && 0 < (data.resultMap).length) {
						 var rowArr = data.resultMap;
			             $.each(rowArr, function(idx, row) {
			            	 comboValue_nm_m.push(rowArr[idx].customer_nm);
			             });
			             if (startValue_combo_m == "") {
		            		 $('#srch_customer_nm').w2field('combo', { items: _.uniq(comboValue_nm_m,false) ,match : 'contains' });
		            	 }
					}
				}
				, error : function(jqXHR, textStatus, errorThrown) {
					fnMessageModalAlert("결과", "검색 고객사 정보를 처리하는데 에러가 발생하였습니다.");
				}
			 });
		}
		
		// srch 자재코드 자재명 자동완성
		function item_code_item_nm_list() {
			console.log("확인");
			var page_url = "/inventory/item_code_item_nm_list";
			var post_data = { 'gubun' : 'P' }
			var startValue_combo_m = "";
			var comboValue_nm_m = [];
			var comboValue_nm_m2 = [];
			
			$.ajax({
				url : page_url
				, type : "POST"
				, data : post_data
				, dataType : "JSON"
				, success : function(data) {
					console.log(data);
					if(data.status == "200" && 0 < (data.resultMap).length) {
						 var rowArr = data.resultMap;
			             $.each(rowArr, function(idx, row) {
			            	 comboValue_nm_m.push(rowArr[idx].item_code);
			            	 comboValue_nm_m2.push(rowArr[idx].item_nm);
			             });
			             if (startValue_combo_m == "") {
		            		 $('#srch_item_code').w2field('combo', { items: _.uniq(comboValue_nm_m,false) ,match : 'contains' });
		            		 $('#srch_item_nm').w2field('combo', { items: _.uniq(comboValue_nm_m2,false) ,match : 'contains' });
		            	 }
					}
				}
				, error : function(jqXHR, textStatus, errorThrown) {
					fnMessageModalAlert("결과", "검색 자재코드 자재명을 처리하는데 에러가 발생하였습니다.");
				}
			 });
		}
		
		//달력 이미지 클릭 시 달력 보이기
		$("#calendar_img").click(function(){
			$('#srch_dlv_req_dt').trigger("click");
		});
		$("#m_calendar_img").click(function(){
			$('#prod_req_dt').trigger("click");
		});
		$("#m_calendar_img2").click(function(){
			$('#m_prod_req_dt').trigger("click");
		});
		
		$("#m_stk_pln_cnt").keyup(function(event) {
			$(this).trigger("change");
		})
		
		$("#m_stk_pln_cnt").change(function(event) {
			value = Number(event.target.value);
			if(value<0 || value==''){
				fnMessageModalAlert("알림", "0 미만의 수 또는 공백은 입력하실 수 없습니다.")
				event.target.value = 0;
				return false;
			}

			var ord_cnt = Number($("#m_ord_cnt").val());  //수주수량
			var m_stk_cnt = Number($("#m_stk_cnt").val()); // 재고량
			var stk_pln_cnt = value; //재고출하량
			var maxProd_pln_cnt = ord_cnt-prod_sum; //최대 지시

//			if(value>m_stk_cnt){
//				fnMessageModalAlert("알림", "현재 재고 수량보다 재고 출하량을 높게 설정 할 수 없습니다.");
//				event.target.value = 0;
//				$("#m_prod_pln_cnt").val(0);
//				return;
//			}
//			
			if(ord_cnt < stk_pln_cnt) {
				fnMessageModalAlert("알림", "수주 수량보다 많이 입력할수 없습니다.");
				$("#m_prod_pln_cnt").val(ord_cnt-maxProd_pln_cnt);
				$("#m_stk_pln_cnt").val(maxProd_pln_cnt);
				return;
			}else if(stk_pln_cnt>maxProd_pln_cnt){
				fnMessageModalAlert("알림", "생산 지시가 " + prod_sum +"개 지시 되어있습니다 <br> 재고출하량을 " + (ord_cnt-prod_sum) + "개 보다 많이 입력할수 없습니다.");
				$("#m_prod_pln_cnt").val(ord_cnt-maxProd_pln_cnt);
				$("#m_stk_pln_cnt").val(maxProd_pln_cnt);
				return;
			}else if(value>m_stk_cnt){
				fnMessageModalAlert("알림", "현재 재고 수량보다 재고 출하량을 높게 설정 할 수 없습니다.");
				event.target.value = m_stk_cnt;
				$("#m_prod_pln_cnt").val(ord_cnt-m_stk_cnt);
				return;
			
			}else{
				var cnt = Number(ord_cnt) - Number(stk_pln_cnt);
				$("#m_prod_pln_cnt").val(cnt);
			}

		});
			
	});
	
	function grid_list_init() {
		$('#grid_list').w2grid({
			name: 'grid_list',
            show: {
                lineNumbers: true,
                footer: true,
                selectColumn:true
            },
			multiSelect : false,
			columns: [
				{field: 'order_no', caption: '수주번호', size: '10%', style: 'text-align:center', sortable : true},
				{field: 'ord_status', caption: '상태', size: '10%', style: 'text-align:center', sortable : true},
				{field: 'dlv_req_dt', caption: '납품요청일', size: '10%', style: 'text-align:center', sortable : true},
				{field: 'ord_dt', caption: '접수일자', size: '10%', style: 'text-align:center', sortable : true},
				{field: 'customer_nm', caption: '고객사', size: '10%', style: 'text-align:center', sortable : true},
				{field: 'order_gubun', caption: '구분', size: '10%', style: 'text-align:center', sortable : true},
				{field: 'item_key', caption: '코드', size: '10%', style: 'text-align:center', sortable : true},
				{field: 'item_code', caption: '번호', size: '10%', style: 'text-align:center', sortable : true},
				{field: 'item_nm', caption: '이름', size: '10%', style: 'text-align:center', sortable : true},
				{field: 'item_spec', caption: '규격', size: '10%', style: 'text-align:center', sortable : true},
// 				{field: 'drw_key', caption: '도면번호', size: '10%', style: 'text-align:center', sortable : true},
				{field: 'ord_cnt', caption: '생산대상수량', size: '10%', style: 'text-align:center', sortable : true},
// 				{field: 'none_ord_cnt', caption: '미납량', size: '10%', style: 'text-align:center', sortable : true},
				{field: 'none_prod_cnt', caption: '생산미편성수량', size: '10%', style: 'text-align:center', sortable : true},
				{field: 'ord_memo', caption: '출하메모', size: '10%', style: 'text-align:center', sortable : true},
				{field: 'memo', caption: '비고', size: '10%', style: 'text-align:center', sortable : true}
			],
			onSelect: function (event) {
				let grid = this;
				w2utils.lock(body, {msg:'loading...', spinner: true, opacity : 0.2 });
				event.onComplete = function () {
					let sel = grid.getSelection();
					if (sel.length && !isloading) {
						cntList();
						loadList2();
						isloading = true;
						
					} else {
					}
				}
			},
			onUnselect: function (event) {
				w2ui['grid_list2'].clear();
				$("#stk_cnt").val(0);
				$("#ord_cnt").val(0);
				$("#stk_pln_cnt").val(0);
				$("#prod_pln_cnt").val(0);
			}
		});
		
	}
	
	function grid_list_init2() {	
		$('#grid_list2').w2grid({
			name: 'grid_list2',
			show: {
				lineNumbers: true,
				footer: true,
				selectColumn:true
			},
			multiSelect : true,
			columns: [
				{field: 'prod_key', caption: '작업지시번호', size: '10%', style: 'text-align:center', sortable : true},
				{field: 'prod_status', caption: '상태', size: '10%', style: 'text-align:center', sortable : true
					,render: function (record, index, col_index) {
						if(record.prod_status =='p1'){
							return "대기"
						}else if(record.prod_status =='p2') {
							return "생산완료"
						}else if(record.prod_status =='p3') {
							return "생산중"
						}
					}	
				},
				{field: 'prc_status', caption: '구매발주상태', size: '10%', style: 'text-align:center', sortable : true},
				{field: 'prod_req_dt', caption: '생산요청일자', size: '10%', style: 'text-align:center', sortable : true},
				{field: 'prod_cnt', caption: '생산지시량', size: '10%', style: 'text-align:center', sortable : true},
				{field: 'cmpl_cnt', caption: '생산수량', size: '10%', style: 'text-align:center', sortable : true},
				{field: 'fault_cnt', caption: '불량수량', size: '10%', style: 'text-align:center', sortable : true}
				],
				onSelect: function (event) {
					let grid = this;
					event.onComplete = function () {
					}
				},
				onUnselect: function (event) {
				}
		});
	}
	
	function grid_list_init3() {
		$('#grid_list3').w2grid({
			name: 'grid_list3',
			show: {
				lineNumbers: true,
				footer: true,
				selectColumn:true
			},
			multiSelect : true,
			columns: [
				{field: 'account_nm', caption: '거래처명', size: '10%', style: 'text-align:center', sortable : true},
				{field: 'account_key', caption: '거래처명', size: '10%', style: 'text-align:center', sortable : true, hidden : true},
				{field: 'account_code', caption: '거래처명', size: '10%', style: 'text-align:center', sortable : true, hidden : true},
				{field: 'gubun_nm', caption: '구분', size: '10%', style: 'text-align:center', sortable : true},
				{field: 'item_key', caption: 'ITEM번호', size: '15%', style: 'text-align:center', sortable : true,},
				{field: 'item_real_code', caption: 'ITEM코드', size: '10%', style: 'text-align:center', sortable : true,},
				{field: 'item_nm', caption: 'ITEM명', size: '10%', style: 'text-align:center', sortable : true},
				{field: 'item_spec', caption: '규격', size: '10%', style: 'text-align:center', sortable : true},
				{field: 'size', caption: '치수', size: '10%', style: 'text-align:center', sortable : true},
				{field: 'meins', caption: '단위', size: '10%', style: 'text-align:center', sortable : true},
				{field: 'stk_cnt', caption: '재고수량', size: '10%', style: 'text-align:center', sortable : true},
				{field: 'prc_cnt', caption: '요청수량', size: '10%', style: 'text-align:center', sortable : true},
				{field: 'price', caption: '단가', size: '10%', style: 'text-align:center', sortable : true},
				{field: 'all_price', caption: '금액', size: '10%', style: 'text-align:center', sortable : true},
				{field: 'dlv_req_dt', caption: '납품요청일', size: '10%', style: 'text-align:center', sortable : true},
				{field: 'memo', caption: '비고', size: '10%', style: 'text-align:center', sortable : true},
				],
				onSelect: function (event) {
					let grid = this;
					event.onComplete = function () {
					}
				},
				onUnselect: function (event) {
				}
		});
		bom_list();
	}
	
	//------------------------------------------------------------------------------------------------------
	// QR코드발행 modal 띄우기
	function tag() {
		var sel_master_row = w2ui['grid_list'].get(w2ui['grid_list'].getSelection()[0]);
			if(sel_master_row) {
				if(w2ui['grid_list2'].records.length != 0) {
					if(w2ui['grid_list2'].getSelection().length > 0){
						console.log(w2ui['grid_list2'].getSelection())
						$("#inModal").modal('show');
						$("#inModal").find('h4').text("QR코드발행");
						
						$("#tag_order_no").val('');
						$("#tag_item_nm").val('');
						$("#tag_item_code").val('');
						$("#tag_prod_key").val('');
						
						$("#tag_order_no").val(sel_master_row.order_no);
						$("#tag_item_nm").val(sel_master_row.item_nm);
						$("#tag_item_code").val(sel_master_row.item_code);
						
						tag_prod_key_num_load();
	//					tag_item_key_load();
	//					tag_prod_key_load();
						all_print();
					}else fnMessageModalAlert("알림", "발행할 tag를 선택해 주세요.");
					
				}else {
					fnMessageModalAlert("알림", "편성된 작업이 없으면 tag 발행을 할수없습니다.");
					return;
				}
				
			}else {
				fnMessageModalAlert("알림", "수주현황을 선택후 Tag 발행을 해주세요.");
			}
		
	}
	
	//------------------------------------------------------------------------------------------------------
	// QR코드발행 modal 띄울때 item_key 가져오기
	function tag_item_key_load() {
		var sel_master_row = w2ui['grid_list'].get(w2ui['grid_list'].getSelection()[0]);
		var item_code = sel_master_row.item_code;
		
		var post_url = "/product/tag_item_key_load";
		var post_data = {
				'item_code' : item_code,
		};
		
		console.log(post_data);
		$.ajax({
			url : post_url,
			type : "POST",
			data : post_data,
			dataType : "JSON",
			async: false,
			success : function (data) {
				if(data.status == "200") {
					$("#tag_item_key").val(data.resultMap[0].item_key);
				}
			},
			error : function(jqXHR, textStatus, errorThrown) {
				fnMessageModalAlert("결과", "정보를 처리하는데 에러가 발생하였습니다.");
			}
		});
	}
	var qrcode = new QRCode("qrcode", {width: 128, height: 128});
	// prod_key num 설정
	function tag_prod_key_num_load(value) {
		
		
		let grid = w2ui['grid_list2'];
		
		console.log(grid.getSelection())
		
		if(value == 'next') chknum++;
		else if (value == 'before') chknum--;	
		else{
			chknum = 1;
			rec_length = grid.getSelection().length;
//			rec_length = w2ui.grid_list2.records.length;
		}
		
		if(rec_length<chknum){
			chknum--;
			return false;
		}
		if(0>=chknum){
			chknum = 1;
			return false;
		}
		let sernr = w2ui.grid_list2.get(grid.getSelection()[chknum-1]).prod_key;
//		$("#qrcode").html('');
		$("#tag_prod_key").val(sernr);
		qrcode.makeCode(sernr);
		$("#sernr_qr").text(sernr)

		
		
		
//		document.getElementById('qrsernr').innerHTML = tagData;
					

	}
	
//	//------------------------------------------------------------------------------------------------------
//	// QR코드발행 modal 띄울때 prod_key 가져오기
//	function tag_prod_key_load(num) {
//		$("#qrcode").empty();
//		var qrcode = new QRCode("qrcode", {width: 128, height: 128});
//		if(!num) {
//			chknum = 1;
//		}
//		
//		if(num > tagDataLength) {
//			num = tagDataLength;
//			chknum = num;
//		}
//		
//		var order_no = sel_master_row.order_no;
//		var post_data = {};
//		var post_url = "/product/tag_prod_key_load"
//		if (num >= 1) {
//			post_data = {
//				'order_no' : order_no,
//				'num' : num
//			};
//		}else {
//			post_data = {
//				'order_no' : order_no,
//			};
//		}
//		
//		console.log(post_data);
//		$.ajax({
//			url : post_url,
//			type : "POST",
//			data : post_data,
//			dataType : "JSON",
//			async: false,
//			success : function (data) {
//				if (!num) {
//					tagDataLength = data.resultMap.length;
//				}
//				if(data.status == "200") {
//					if(data.resultMap != null && data.resultMap != undefined) {
//						$("#qrcode").append("<br/>");
//						$("#qrcode").append("<label>" + data.resultMap[0].prod_key + "</label>");
//						$("#tag_prod_key").val(data.resultMap[0].prod_key);
//						
//						let tagData = $("#tag_prod_key").val();
//						qrcode.makeCode(tagData);
//						
//						document.getElementById('qrsernr').innerHTML = tagData;
//					}
//				}
//			},
//			error : function(jqXHR, textStatus, errorThrown) {
//				fnMessageModalAlert("결과", "정보를 처리하는데 에러가 발생하였습니다.");
//			}
//		});
//	}
	
	//------------------------------------------------------------------------------------------------------
	// tag 출력
	function print_qr(target) {
		var print_area = document.getElementById(target);
		var print_option = 'left=350,top=0,width=800,height=900,toolbar=0,scrollbars=0,status=0';
		var open_print = window.open('', '', print_option);
		open_print.document.write(print_area.innerHTML);
		open_print.document.close();
		open_print.focus();
		
		setTimeout(()=>{
			open_print.print();
			open_print.close();
		}, 200)		
				
	}
	
	//------------------------------------------------------------------------------------------------------
	// tag 일괄출력
	function all_print(){
		$("#qrcode_all").empty();
		var sel_master_row = w2ui['grid_list'].get(w2ui['grid_list'].getSelection()[0]);
		
		var order_no = sel_master_row.order_no;
		var order_seq = sel_master_row.order_seq;
		var post_data = {};
		var post_url = "/product/tag_prod_key_load"
			post_data = {
				'order_no' : order_no,
				'order_seq' : order_seq
			};
		
		$.ajax({
			url : post_url,
			type : "POST",
			data : post_data,
			dataType : "JSON",
			async: false,
			success : function (data) {
				tagDataLength = data.resultMap.length;
				if(data.status == "200") {
					if(data.resultMap != null && data.resultMap != undefined) {
						for(var i = 0; i < tagDataLength; i++) {
							var qrcode = new QRCode("qrcode_all", {width: 128, height: 128});		
							$("#qrcode_all").append("<br/>");
							$("#qrcode_all").append("<label>" + data.resultMap[i].prod_key + "</label>");
						    let tagData = data.resultMap[i].prod_key;
							qrcode.makeCode(tagData);
							$("#qrcode_all").append("<br/><br/><br/><br/>");
						}
					}
				}
			},
			error : function(jqXHR, textStatus, errorThrown) {
				fnMessageModalAlert("결과", "정보를 처리하는데 에러가 발생하였습니다.");
			}
		});
		
	}
	
	
	//------------------------------------------------------------------------------------------------------


	//------------------------------------------------------------------------------------------------------
	// 구매발주등록 modal 띄우기
	function insertOrder() {
		var sel_master_row2 = w2ui['grid_list2'].get(w2ui['grid_list2'].getSelection()[0]);
		if(sel_master_row2) {
			console.log(sel_master_row2)
			if(sel_master_row2.prod_status == "p2") {
				fnMessageModalAlert("알림", "이미 생산이 완료된 작업입니다. ");
			}else if(sel_master_row2.prc_status != '') {
				fnMessageModalAlert("알림", "해당 작업의 구매 발주 이력이 존재합니다 <br>구매 발주 이력이 없는 작업만 구매 발주 등록을 하 실 수 있습니다. <br>추가 등록을 원하시면 구매 발주 관리 페이지로 이동해주세요.");
			}else {
				$("#insertModal").modal('show');
				$("#insertModal").find('h4').text("구매발주등록");
				
			}
		}else {
			fnMessageModalAlert("알림", "편성 되어있는 작업을 먼저 선택해주세요.");
		}
		
	}
	
	//------------------------------------------------------------------------------------------------------
	// 구매발주등록 modal list 띄우기 & 구매발주등록
	function bom_list() {
		
		var sel_master_row2 = w2ui['grid_list2'].get(w2ui['grid_list2'].getSelection()[0]);
		
		var prod_key = sel_master_row2.prod_key;
		var item_key = sel_master_row2.item_key;
		
		var post_url = "/product/ipt_item_list"
		var post_data = {
				'prod_key' : prod_key,
				'item_key' : item_key,
		};
		
		console.log(post_data);
		$.ajax({
			url : post_url,
			type : "POST",
			data : post_data,
			dataType : "JSON",
			success : function (data) {
				if(data.status == "200") {
					console.log(data);
					if ((data.resultMap).length > 0) {
						rowArr = data.resultMap;
						console.log(rowArr);
						$.each(rowArr, function(idx, row) {
							row.recid = idx + 1;
						});
						w2ui['grid_list3'].records = rowArr;
					} else {
						$("#insertModal").modal('hide');
						w2ui['grid_list3'].clear();
						setTimeout(()=>{
							fnMessageModalAlert("결과", "구매발주를 진행하기 위한 하위 레벨의 자재들이 없습니다.");
						}, 500)
					}
				}
				w2ui['grid_list3'].refresh();
				w2ui['grid_list3'].unlock();
			},
			error : function(jqXHR, textStatus, errorThrown) {
				fnMessageModalAlert("결과", "정보를 처리하는데 에러가 발생하였습니다.");
			}
		});
		
	}
	
	function save_mat() {
		console.log("ckslcksl")
		var strUrl = "/product/save_prc_mat";
		var data_chk = w2ui['grid_list3'].records;
		var data = [];
		var sel_master_row2 = w2ui['grid_list2'].get(w2ui['grid_list2'].getSelection()[0]);
		
		let totcnt = 0;
		for(var i=0;i<data_chk.length;i++){
			
			var data_all = w2ui.grid_list3.records[i];
			
			console.log(w2ui['grid_list3'].get(i+1));
// 			sel_master_row3 = w2ui['grid_list3'].get(i+1); // getSelection()[0]
			if(data_all.prc_cnt == undefined || data_all.account_key == undefined){
				fnMessageModalConfirm("알림", data_all.item_nm + "의 요청수량을 입력받지 못했습니다 <br>구매 발주를 위해 요청수량을 입력하시겠습니까?", function(result) {
					if (result) {
						purch_update();
					}else {
						setTimeout(()=>{
							fnMessageModalAlert("결과", "요청 수량을 모두 입력하셔야 구매발주 등록이 가능합니다 <br>구매 발주가 필요없는 아이템은 선택 후 상단의 삭제버튼을 눌러주세요.");
						}, 500)
					} 
				})
				return;
			}
			console.log(data_all);
			totcnt += data_all.prc_cnt;
			
			account_key = data_all.account_key;
			account_nm = data_all.account_nm;
			item_key = data_all.item_key;
			item_code = data_all.item_real_code;
			item_nm = data_all.item_nm;
			req_cnt = data_all.prc_cnt;
			price =  data_all.price;
			dlv_req_dt = data_all.dlv_req_dt;
			prod_key = sel_master_row2.prod_key;
			
			data.push({
				"prod_key" : prod_key,
				"account_key" : account_key,
				"account_nm" : account_nm,
				"item_key" : item_key,
				"item_code" : item_code,
				"item_nm" : item_nm,
				"req_cnt" : req_cnt,
				"price" : price,
				"dlv_req_dt" : dlv_req_dt
			});
		}
		
		console.log(totcnt);
		if(totcnt==0){
			fnMessageModalConfirm("알림", "구매발주 할 수량이 0개입니다<br> 이대로 구매발주등록을 완료처리 하시겠습니까?", function(result) {
				if (result) {
					$("#insertModal").modal('hide');
				}
			})
			return;
		}
		
		var jsondata = JSON.stringify(data);
		console.log(jsondata);
		fnMessageModalConfirm("알림", "저장하시겠습니까?", function(result) {

			if (result) {
				
				w2utils.lock(body, {msg:'loading...', spinner: true, opacity : 0.2 });
				
				 $.ajax({
					 url : strUrl,
					 type : "POST",
					 data : {'jsondata' : jsondata},
					 success : function(data, textStatus, jqXHR) {
						 if (data.status == "200") {
							 $("#insertModal").modal('hide');
							 var key = w2ui['grid_list'].getSelection();
							 var sel_data = w2ui['grid_list'].get(key[0]);
						
						
							 loadList(sel_data);
						 }
					 },
					 error : function(jqXHR, textStatus, errorThrown) {
						 fnMessageModalAlert("결과", "정보를 처리하는데 에러가 발생하였습니다.");
					 },
					 complete : function() {
						 w2utils.unlock(body);
					 }
				 });
			}else {
				return;
			}
		});
		
	}
	
	
	
	
	
	function purch_saveBtn() {
		if(!$("#update_account_nm").val()) {
			fnMessageModalAlert("알림", "거래처명이 입력되지 않았습니다 확인해주세요.");
			return;
		}else if(!$("#update_account_key").val()) {
			fnMessageModalAlert("알림", "거래처키가 입입력되지 않았습니다 확인해주세요.");
			return;
		}else if(!$("#update_item_key").val()) {
			fnMessageModalAlert("알림", "자재키가 입력되지 않았습니다 확인해주세요.");
			return;
		}else if(!$("#update_item_code").val()) {
			fnMessageModalAlert("알림", "자재코드가 입력되지 않았습니다 확인해주세요.");
			return;
		}else if(!$("#update_item_nm").val()) {
			fnMessageModalAlert("알림", "자재명이 입력되지 않았습니다 확인해주세요.");
			return;
		}else if(!$("#update_prc_cnt").val()) {
			fnMessageModalAlert("알림", "요청수량이 입력되지 않았습니다 확인해주세요.");
			return;
		}else if(!$("#update_price").val()) {
			fnMessageModalAlert("알림", "단가가 입력되지 않았습니다 확인해주세요.");
			return;
		}else if(!$("#update_dlv_req_dt").val()) {
			fnMessageModalAlert("알림", "납품요청일자가 입력되지 않았습니다 확인해주세요.");
			return;
		}
		
		var account_nm_value = $("#update_account_nm").val();
		var account_key_value = $("#update_account_key").val();
		var account_code_value = $("#update_account_code").val();
		var prc_cnt_value = $("#update_prc_cnt").val();
		var price_value = $("#update_price").val();
		var all_price_value = (Number($("#update_price").val()) * Number($("#update_prc_cnt").val()));
		var dlv_req_dt_value = $("#update_dlv_req_dt").val();
		var memo_value = $("#update_memo").val();
		
		var sel_master_row3 = w2ui['grid_list3'].get(w2ui['grid_list3'].getSelection()[0]);
		
		w2ui.grid_list3.set(sel_master_row3.recid, { account_nm : account_nm_value,
													account_key : account_key_value, 
													account_code : account_code_value,
													prc_cnt : prc_cnt_value,
													price : price_value,
													all_price : all_price_value,
													dlv_req_dt : dlv_req_dt_value,
													memo : memo_value });
		$("#updateModal").modal('hide');
		
		/*
		fnMessageModalConfirm("알림", "저장하시겠습니까?", function(result) {
			if(result) {
				
				var account_nm_value = $("#update_account_nm").val();
				var account_key_value = $("#update_account_key").val();
				var account_code_value = $("#update_account_code").val();
				var prc_cnt_value = $("#update_prc_cnt").val();
				var price_value = $("#update_price").val();
				var all_price_value = (Number($("#update_price").val()) * Number($("#update_prc_cnt").val()));
				var dlv_req_dt_value = $("#update_dlv_req_dt").val();
				var memo_value = $("#update_memo").val();
				
				w2ui.grid_list3.set(sel_master_row3.recid, { account_nm : account_nm_value,
															account_key : account_key_value, 
															account_code : account_code_value,
															prc_cnt : prc_cnt_value,
															price : price_value,
															all_price : all_price_value,
															dlv_req_dt : dlv_req_dt_value,
															memo : memo_value });
				$("#updateModal").modal('hide');
			}else {
				return;
			}
		});	
		*/
		
	}
	
	//------------------------------------------------------------------------------------------------------
	// 구매발주 등록에서 수정모달 띄우기
	function purch_update() {
		var sel_master_row3 =  w2ui['grid_list3'].get(w2ui['grid_list3'].getSelection()[0]);
		
		if(sel_master_row3) {
			$("#updateModal").modal('show');
			$("#update_item_key").val('');
			$("#update_item_code").val('');
			$("#update_item_nm").val('');
			$("#update_price").val('');
			$("#update_stk_cnt").val('');
			$("#update_prc_cnt").val('');
			$("#update_account_key").val('');
			$("#update_account_code").val('');
			$("#update_account_nm").val('');
			$("#update_price").val('');
			$("#update_memo").val('');
			$("#updateModal").find('h4').text("수정");
			modalSetCel();
			$("#update_item_key").val(sel_master_row3.item_key);
			$("#update_item_code").val(sel_master_row3.item_real_code);
			$("#update_item_nm").val(sel_master_row3.item_nm);
			$("#update_price").val(sel_master_row3.price.replaceAll(',',''));
			$("#update_stk_cnt").val(sel_master_row3.stk_cnt);
		}else {
			fnMessageModalAlert("알림", "항목을 먼저 선택해주세요.");
		}
	}
	
	//------------------------------------------------------------------------------------------------------
	// 구매발주 등록에서 발주 필요없는 행 지우기
	function purch_delete() {
		var sel_master_row3 =  w2ui['grid_list3'].get(w2ui['grid_list3'].getSelection()[0]);
		if(sel_master_row3) {
			fnMessageModalConfirm("알림", "해당 항목을 삭제하시겠습니까?", function(result) {
				if(result) {
					w2ui['grid_list3'].delete(sel_master_row3.recid);
				}else {
					return;
				}
			});
		}else {
			fnMessageModalAlert("알림", "항목을 먼저 선택해주세요.");
		}
	}
	
	
	//------------------------------------------------------------------------------------------------------
	// 등록 편성 modal 띄우기 & 편성 modal 저장 & 삭제
	function insert() {
		var sel_master_row = w2ui['grid_list'].get(w2ui['grid_list'].getSelection()[0]);
		if(sel_master_row) {
			let sum = 0;
			let length = w2ui['grid_list2'].records.length;
			for(var i = 0; i < length; i++) {
				sum += w2ui['grid_list2'].records[i].prod_cnt;
			}


			
			
			if($("#ord_cnt").val() == $("#stk_pln_cnt").val())
			{
				fnMessageModalAlert("알림", "생산편성대상수량이 없습니다.<br>해당 건은 모두 재고로 처리됐습니다.");
			}else if($("#prod_pln_cnt").val()==0) {
				fnMessageModalConfirm("알림", "생산편성 수량을 지정하지 않았습니다.<br> 생산편성 수량을 지정하시겠습니까?", function(result) {
					if(result) {
						update()
					}
					return;
				})
//				

				
			}else if(sum >= $("#prod_pln_cnt").val()){

				fnMessageModalAlert("알림", "이미 생산편성대상수량 만큼 작업지시를 편성하셨습니다.");
			}else {
				var post_url = "/product/routing_check";
				var post_data = { 
					"item_key" : sel_master_row.item_key,
				}
				
				$.ajax({
					
					url : post_url,
					data : post_data,
					type : "POST",
					dataType : "JSON",
					success : function (data) {
						var len = data.resultMap.length;
						if(len == 0) {
							fnMessageModalAlert("알림", "해당 제품에 해당하는 공정이 존재하지 않습니다 공정관리를 먼저 확인해주세요.");
							return;
						}else {
							
								$("#insertModal2").modal('show');
								$("#insertModal2").find('h4').text("등록");
								
								$("#prod_req_dt").val('');
								$("#prod_cnt").val('');
								
								insertModalSetCel();
						}
					},
					error : function(jqXHR, textStatus, errorThrown) {
						fnMessageModalAlert("결과", "저장중 에러가 발생하였습니다.");
					}
				});
			}
		}else {
			fnMessageModalAlert("알림", "항목을 선택후 등록해주세요.");
		}
	}
	
	function save_organization() {
		let sum = 0;
		
		var sel_master_row = w2ui['grid_list'].get(w2ui['grid_list'].getSelection()[0]);
		
		for(var i = 0; i < w2ui['grid_list2'].records.length; i++) {
			sum += w2ui['grid_list2'].records[i].prod_cnt;
//			fault_cnt += w2ui['grid_list2'].records[i].fault_cnt;
		}
		
		var chk_cnt = Number($("#prod_pln_cnt").val() - sum);
		
		
		console.log(chk_cnt)
		console.log(Number($("#prod_cnt").val()))

		
		if(chk_cnt < Number($("#prod_cnt").val()) ) {
			fnMessageModalAlert("알림", chk_cnt + "개 이상 지시 할수 없습니다.");
			$("#prod_cnt").val(chk_cnt);
			return;
		}
		
		fnMessageModalConfirm("알림", "저장하시겠습니까?", function(result) {
			if(result) {
				
				var item_key  	= sel_master_row.item_key;
				var order_no 	= sel_master_row.order_no;
				var order_seq 	= sel_master_row.order_seq;
				
				var prod_cnt	= Number($("#prod_cnt").val());
				var prod_req_dt	= $("#prod_req_dt").val();
				
				
				var prc_key = sel_master_row.prc_key;
				var page_url = "/product/save_organization";
				var post_data = {
						'item_key' 		: item_key,
						'prod_cnt' 		: prod_cnt,
						'prod_req_dt' 	: prod_req_dt,
						'order_no' 		: order_no,
						'order_seq'		: order_seq
				};
				$.ajax({
					url : page_url,
					data : post_data,
					type : 'POST',
					dataType : 'json',
					success : function(data) {
						fnMessageModalAlert("결과", "지시 생성이 완료되었습니다.");
						$("#insertModal2").modal('hide');
						
						var key = w2ui['grid_list'].getSelection();
						var sel_data = w2ui['grid_list'].get(key[0]);
						
						
						loadList(sel_data);
// 						cntList();
// 						loadList2();
// 						w2ui['grid_list'].refresh();
// 						w2ui['grid_list2'].clear();
					},
					error : function(jqXHR, textStatus, errorThrown) {
						fnMessageModalAlert("결과", "저장중 에러가 발생하였습니다.");
					}
				});
				
			}else {
				return;
			}
		});
		
	}
	
	function delete_organization() {
		var sel_master_row = w2ui['grid_list'].get(w2ui['grid_list'].getSelection()[0]);
		var sel_master_row2 = w2ui['grid_list2'].get(w2ui['grid_list2'].getSelection()[0]);
		console.log(sel_master_row2.prod_status)
		
		if(sel_master_row2.prod_status == 'p1') {
			var prod_key = sel_master_row2.prod_key;
			var prod_cnt = sel_master_row2.prod_cnt;
			var order_no = sel_master_row.order_no;
			
			var post_data = {
				'prod_key' : prod_key,
			};
			
			var post_url = "/product/delete_organization";
			fnMessageModalConfirm("알림", "삭제하시겠습니까?", function(result) {
				if(result) {
					$.ajax({
						url : post_url,
						type : "POST",
						data : post_data,
						dataType : "JSON",
						async: false,
						success : function (data) {
							if(data.status == "200") {
								loadList();
								cntList();
								loadList2();
		//						location.reload();
							}
						},
						error : function(jqXHR, textStatus, errorThrown) {
							fnMessageModalAlert("결과", "정보를 처리하는데 에러가 발생하였습니다.");
						}
					});
				}
			})
			
			
		}else {
			fnMessageModalAlert("결과", "대기중인 작업만 삭제 가능합니다.");
		}
	}
	
	//------------------------------------------------------------------------------------------------------
	// 수정 modal 띄우기
	function update() {
		prod_sum = 0;
		var sel_master_row = w2ui['grid_list'].get(w2ui['grid_list'].getSelection()[0]);
		console.log(sel_master_row)
		let length = w2ui['grid_list2'].records.length;
		if(sel_master_row.ord_status=='출하준비완료'){
			fnMessageModalAlert("결과", "출하 준비 상태에서는 생산편성 수량을 수정 하실 수 없습니다");
			return;
		}else if(sel_master_row.ord_status=='출하완료'){
			fnMessageModalAlert("결과", "이미 출하가 완료된 항목입니다");
			return;
		}
		
		for(var i = 0; i < length; i++) {
			prod_sum += w2ui['grid_list2'].records[i].prod_cnt;
			if(w2ui['grid_list2'].records[i].prod_status=='p2'){
				fnMessageModalAlert("결과", "생산 완료 된 항목이 존재합니다. <br>생산 편성 수량을 수정 하실 수 없습니다");
				return;
			}
		}
		
		$("#inModal2").modal('show');
		$("#inModal2").find('h4').text("수정");
		$("#m_stk_cnt").val($("#stk_cnt").val());
		$("#m_prod_pln_cnt").val($("#prod_pln_cnt").val()==0 ? $("#ord_cnt").val() : $("#prod_pln_cnt").val());
		$("#m_ord_cnt").val($("#ord_cnt").val());
		$("#m_stk_pln_cnt").val($("#stk_pln_cnt").val());
	}
	const useAjax = (sendURL, postData) => {
		$.ajax({
			url : sendURL,
			type : "POST",
			data : postData,
			dataType : "JSON",
			success : function (data) {
				if(data.status == "200") {
					fnMessageModalAlert("결과", "수정이 완료되었습니다");
					$("#inModal2").modal('hide');
					loadList();
					cntList();
					loadList2();
				}
			},
			error : function(jqXHR, textStatus, errorThrown) {
				fnMessageModalAlert("결과", "정보를 처리하는데 에러가 발생하였습니다.");
			}
		});
	}


	//------------------------------------------------------------------------------------------------------
	//수정 cntList 저장
	function cnt_update() {
		var sel_master_row = w2ui['grid_list'].get(w2ui['grid_list'].getSelection()[0]);
		var m_prod_pln_cnt = $("#m_prod_pln_cnt").val();
		var m_stk_pln_cnt = $("#m_stk_pln_cnt").val();
		var order_no = sel_master_row.order_no;
		var order_seq = sel_master_row.order_seq;
		
		post_data = {
			'order_no' : order_no,
			'order_seq' : order_seq,
			'prod_pln_cnt' : m_prod_pln_cnt,
			'stk_pln_cnt' : m_stk_pln_cnt
		};
		if($("#m_prod_pln_cnt").val()==0){
			fnMessageModalConfirm("알림", "모든 수량을 재고로 출하처리를 하여 바로 출하 준비 단계로 넘어 갑니다<br>생산을 건너 뛰고 바로 출하 준비를 하시겠습니까?", function(result) {
				if(result) {
					post_data.ord_status = 'o3';
					

					post_url = "/product/cnt_update";
					$.ajax({
						url : post_url,
						type : "POST",
						data : post_data,
						dataType : "JSON",
						success : function (data) {
							if(data.status == "200") {
								fnMessageModalAlert("결과", "수정이 완료되었습니다");
								$("#inModal2").modal('hide');
								
								var key = w2ui['grid_list'].getSelection();
								var sel_data = w2ui['grid_list'].get(key[0]);
						
								loadList(sel_data);
							}
						},
						error : function(jqXHR, textStatus, errorThrown) {
							fnMessageModalAlert("결과", "정보를 처리하는데 에러가 발생하였습니다.");
						}
					});
				}
			})
			
		}else{
			fnMessageModalConfirm("알림", "수정하시겠습니까?", function(result) {
				if(result) {
					post_url = "/product/cnt_update";
					$.ajax({
						url : post_url,
						type : "POST",
						data : post_data,
						dataType : "JSON",
						success : function (data) {
							if(data.status == "200") {
								fnMessageModalAlert("결과", "수정이 완료되었습니다");
								$("#inModal2").modal('hide');
								
								var key = w2ui['grid_list'].getSelection();
								var sel_data = w2ui['grid_list'].get(key[0]);
						
								loadList(sel_data);
							}
						},
						error : function(jqXHR, textStatus, errorThrown) {
							fnMessageModalAlert("결과", "정보를 처리하는데 에러가 발생하였습니다.");
						}
					});
				}else {
					return;
				}
			});
		}
		
		
	}
	
	//------------------------------------------------------------------------------------------------------
	// main 화면 조회
	function loadList(sel_data) {
		
		w2ui['grid_list2'].clear();
		
		var post_url = "/product/prdc_order_mng_main_list";
		
		let pwo_order_date = $("#srch_dlv_req_dt").val().replaceAll(".", "");
	    let order_from_date = pwo_order_date.substr(0, 8);
        let order_to_date = pwo_order_date.substr(11);
		
		var post_data = {
			'from_dlv_req_dt' : order_from_date,
			'to_dlv_req_dt' : order_to_date,
			'customer_nm' : $("#srch_customer_nm").val(),
			'item_code' : $("#srch_item_code").val(),
			'item_nm' : $("#srch_item_nm").val(),
			'ord_status' : $("#srch_ord_status").val(),
			'order_no' : $("#order_no").val(),
		};
		w2ui['grid_list'].clear();
		setTimeout(()=>{
			w2ui['grid_list2'].clear();
		},200)
		
		
		console.log(post_data);
		$.ajax({
			url : post_url,
			type : "POST",
			data : post_data,
			dataType : "JSON",
			success : function (data) {
				console.log(data);
				if(data.status == "200") {
					if ((data.resultMap).length > 0) {
						rowArr = data.resultMap;
						$.each(rowArr, function(idx, row) {
							row.recid = idx + 1;
						});
						w2ui['grid_list'].records = rowArr;
					} else {
						w2ui['grid_list'].clear();
					}
					
					w2ui['grid_list'].refresh();
					w2ui['grid_list'].unlock();
					
					$("#stk_cnt").val(0);
					$("#ord_cnt").val(0);
					$("#stk_pln_cnt").val(0);
					$("#prod_pln_cnt").val(0);
					
					$("#popover_btn").css("display","none");
					
					
					
					if(sel_data != undefined)
					{
						var arr = _.filter(w2ui['grid_list'].records, {order_no:sel_data.order_no, order_seq:sel_data.order_seq});
						
						if(arr.length != 0)
						{
							w2ui['grid_list'].select(arr[0].recid);
							w2ui['grid_list'].scrollIntoView(arr[0].recid-1);
						}
					}
					
					
				}
				
			},
			error : function(jqXHR, textStatus, errorThrown) {
				fnMessageModalAlert("결과", "정보를 처리하는데 에러가 발생하였습니다.");
			}
		});
	}
	
	//------------------------------------------------------------------------------------------------------
	// 편성 cnt 조회
	function cntList() {
		var sel_master_row = w2ui['grid_list'].get(w2ui['grid_list'].getSelection()[0]);
		post_url = "/product/cntList";
		post_data = {
			'item_key' : sel_master_row.item_key,
			'order_no' : sel_master_row.order_no,
			'order_seq' : sel_master_row.order_seq
		};
		
		$.ajax({
			url : post_url,
			type : "POST",
			data : post_data,
			dataType : "JSON",
			success : function (data) {
				if(data.status == "200") {
					console.log(data)
					$("#stk_cnt").val(data.resultMap[0].stk_cnt);
					$("#ord_cnt").val(data.resultMap[0].ord_cnt);
					$("#stk_pln_cnt").val(data.resultMap[0].stk_pln_cnt);
					$("#prod_pln_cnt").val(data.resultMap[0].prod_pln_cnt);
				}
			},
			error : function(jqXHR, textStatus, errorThrown) {
				fnMessageModalAlert("결과", "정보를 처리하는데 에러가 발생하였습니다.");
			}
		});
		
	}

	//------------------------------------------------------------------------------------------------------
	// 편성 grid 조회
	function loadList2() {
		var sel_master_row = w2ui['grid_list'].get(w2ui['grid_list'].getSelection()[0]);
		fault_cnt = 0;
		prod_sum = 0;
		isloading = true;
		var order_no = sel_master_row.order_no;
		var order_seq = sel_master_row.order_seq;
		
		w2ui['grid_list2'].lock("now loading");
		
		post_url = "/product/prdc_order_mng_organization_list";
		post_data = {
			'order_no' : order_no,
			'order_seq' : order_seq
		};
		$.ajax({
			url : post_url,
			type : "POST",
			data : post_data,
			dataType : "JSON",
			success : function (data) {
				if(data.status == "200") {
					if ((data.resultMap).length > 0) {
						rowArr = data.resultMap;
						$.each(rowArr, function(idx, row) {
							row.recid = idx + 1;
							fault_cnt += row.fault_cnt;
							prod_sum += row.prod_cnt;
						});
						console.log(fault_cnt)
						w2ui['grid_list2'].records = rowArr;
					} else {
						$("#popover_btn").css("display","none");
						w2ui['grid_list2'].clear();
					}
				}
				w2ui['grid_list2'].refresh();
				w2ui['grid_list2'].unlock();
			},
			error : function(jqXHR, textStatus, errorThrown) {
				fnMessageModalAlert("결과", "정보를 처리하는데 에러가 발생하였습니다.");
			},
			complete : () => {
				isloading = false;
				if(fault_cnt>0 && !isloading){
							$("#popover_btn").text(fault_cnt);
							$("#popover_btn").css("display","")
				} else $("#popover_btn").css("display","none");
				
				w2utils.unlock(body);
			}
		});
		
	}
	
	//------------------------------------------------------------------------------------------------------
	// 납품 요청 일자 날짜 setting
	function getFormatDate(d) {
		var month = d.getMonth() + 1;
		var date = d.getDate();
		month = (month < 10) ? "0" + month : month;
		date = (date < 10) ? "0" + date : date;
		return d.getFullYear() + '-' + month + '-' + date;
	}
	
	function fnLoadCommonOption() {
	 		var minDate = getFormatDate(new Date());
			 $('input:text[name=srch_dlv_req_dt]').daterangepicker({
					opens: 'right',
					showDropdowns: true,
					locale: {
						format : 'YYYYMMDD'	,
						monthNames : [ '1월', '2월', '3월', '4월', '5월', '6월',
								'7월', '8월', '9월', '10월', '11월', '12월' ],
						daysOfWeek: [ "일","월", "화", "수", "목", "금", "토" ],
						showMonthAfterYear : true,
						yearSuffix : '년',
						applyLabel: '확인',
						cancelLabel: '취소'
				    },
				    startDate: moment(minDate).add(-6, 'months'),
				    endDate: moment(minDate).add(6, 'months')
				    
				});
	}
	
	function insertModalSetCel() {
 		var minDate = getFormatDate(new Date());
		 $('input:text[name=prod_req_dt]').daterangepicker({
			singleDatePicker: true,
			opens: 'right',
			locale: {
				format : 'YYYYMMDD'	,
				monthNames : [ '1월', '2월', '3월', '4월', '5월', '6월',
						'7월', '8월', '9월', '10월', '11월', '12월' ],
				daysOfWeek: [ "일","월", "화", "수", "목", "금", "토" ],
				showMonthAfterYear : true,
				yearSuffix : '년'
		    },
		 }); 
	}
	
	
	//------------------------------------------------------------------------------------------------------
	// main excel download
	function excelFileDownload() {
		var gridCols = w2ui['grid_list'].columns;
		var gridData = w2ui['grid_list'].records;
		var date = new Date();
		var year = date.getFullYear().toString();
		var month = date.getMonth() + 1;
	   		month = month < 10 ? '0' + month.toString() : month.toString();
	    var day = date.getDate();
	   		day = day < 10 ? '0' + day.toString() : day.toString();
	   		
		var fileName = '생산 지시 관리_'+year+month+day+'.xlsx';
		var sheetTitle = '생산 지시 관리';
		var sheetName = '생산 지시 관리';

		var param_col_name = "", param_col_id = "", param_col_align = "", param_col_width = "";

		var is_rownum = true;

		if (gridCols != null && gridCols.length > 0) {
			for (var i = 0; i < gridCols.length; i++) {
				if (!gridCols[i].hidden) {
					param_col_name += gridCols[i].caption + ",";
					param_col_id += gridCols[i].field + ",";
					param_col_align += "center" + ",";
					param_col_width += (gridCols[i].width == undefined ? "10"
							: (gridCols[i].width).replace('px', ''))
							+ ",";
				}
			}
			param_col_name = param_col_name.substr(0, param_col_name.length - 1);
			param_col_id = param_col_id.substr(0, param_col_id.length - 1);
			param_col_align = param_col_align.substr(0, param_col_align.length - 1);
			param_col_width = param_col_width.substr(0, param_col_width.length - 1);
		}

		var export_url = "/export/export_client_jqgrid";
		var export_data = "file_name=" + encodeURIComponent(encodeURIComponent(fileName));
		export_data += "&sheet_title=" + encodeURIComponent(sheetTitle);
		export_data += "&sheet_name=" + encodeURIComponent(sheetName);
		export_data += "&header_col_names=" + encodeURIComponent(param_col_name);
		export_data += "&header_col_ids=" + encodeURIComponent(param_col_id);
		export_data += "&header_col_aligns=" + encodeURIComponent(param_col_align);
		export_data += "&header_col_widths=" + encodeURIComponent(param_col_width);
		export_data += "&cmd=" + encodeURIComponent("grid_goods_detail");
		export_data += "&body_data=" + encodeURIComponent(JSON.stringify(gridData));

		$.ajax({
			url : export_url,
			data : export_data,
			type : 'POST',
			dataType : 'json',
			success : function(data) {
				if (data.status == 200) {
					var file_path = data.file_path;
					var file_name = data.file_name;
					var protocol = jQuery(location).attr('protocol');
					var host = jQuery(location).attr('host');
					var link_url = "/file/attach_download";
					link_url += "?file_path="
							+ encodeURIComponent(file_path);
					link_url += "&file_name="
							+ encodeURIComponent(file_name);

					$(location).attr('href', link_url);
				}
			},
			complete : function() {
			}
		});
	}
	
	function getFormatDate(d) {
		var month = d.getMonth() + 1;
		var date = d.getDate();
		month = (month < 10) ? "0" + month : month;
		date = (date < 10) ? "0" + date : date;
		return d.getFullYear() + '-' + month + '-' + date;
	}
	
	function modalSetCel() {
 		var minDate = getFormatDate(new Date());
		 $('input:text[name=update_dlv_req_dt]').daterangepicker({
			singleDatePicker: true,
			opens: 'right',
			locale: {
				format : 'YYYYMMDD'	,
				monthNames : [ '1월', '2월', '3월', '4월', '5월', '6월',
						'7월', '8월', '9월', '10월', '11월', '12월' ],
				daysOfWeek: [ "일","월", "화", "수", "목", "금", "토" ],
				showMonthAfterYear : true,
				yearSuffix : '년'
		    },
		 }); 
	}
	
	function delete_ord_dtl_info()
	{
		var key = w2ui['grid_list'].getSelection();
		if(key == 0)
		{
			fnMessageModalAlert("알림", "선택된 항목이 없습니다.");
		}
		
		fnMessageModalConfirm("알림", "선택항목을 초기화하시겠습니까?<br>초기화 시 해당항목은 대기상태로 돌어갑니다.", function(result) {
			if (result) {
				var sel_data = w2ui['grid_list'].get(key[0]);
			  				
				var page_url = "/product/delete_ord_dtl_info";
				var postData = "order_no=" + encodeURIComponent(sel_data.order_no);
				postData += "&order_seq=" + encodeURIComponent(sel_data.order_seq);
				
				w2ui['grid_list'].lock('loading...', true); 
				$.ajax({
					  url:page_url,
					  data:postData,
					  type:'POST',
					  success : function(data, textStatus, jqXHR) {
					  	if(data.status == 200) {		  	
							if(data.msg == "생산종료") {
								fnMessageModalAlert("알림", "해당 수주건은 이미 출하준비완료 단계까지 진행된 오더입니다.<br>초기화가 불가합니다.");
							} else {
								fnMessageModalAlert("알림", "초기화를 완료했습니다.");	
								loadList();
							}
					  			
					  	} else {
					  		fnMessageModalAlert("알림", "요청처리를 실패했습니다.");
					  	}
					  },
					  error : function(jqXHR, textStatus, errorThrown) {
						  fnMessageModalAlert("알림",	"요청처리를 실패했습니다.");
					  },
					  complete: function () {
						  w2ui['grid_list'].unlock();
					  }
				});
			}
		})
		
		
	}
	
	function autoInsertModalSetCel() {
 		var minDate = getFormatDate(new Date());
		 $('#m_prod_req_dt').daterangepicker({
			singleDatePicker: true,
			opens: 'right',
			locale: {
				format : 'YYYYMMDD'	,
				monthNames : [ '1월', '2월', '3월', '4월', '5월', '6월',
						'7월', '8월', '9월', '10월', '11월', '12월' ],
				daysOfWeek: [ "일","월", "화", "수", "목", "금", "토" ],
				showMonthAfterYear : true,
				yearSuffix : '년'
		    },
		 }); 
	}
	
	function auto_cnt_update(){
		
		var key = w2ui['grid_list'].getSelection();
		
		if(key.length == 0){
			fnMessageModalAlert("알림","편성하실 수주번호 하나를 선택해주세요.");
			return;
		}
		$('#m_prod_req_dt').val('');
		autoInsertModalSetCel();
		$("#autoInsertModal").modal('show');
		
	}
	
	function auto_save_organization() {
		
		var key = w2ui['grid_list'].getSelection();
		var get_data = w2ui['grid_list'].get(key[0]);
		
		var grid = w2ui['grid_list'].records;
		
		var grid_data = [];
		for(var i = 0; i < grid.length; i++){
			if(get_data.order_no == grid[i].order_no){
				grid_data.push(grid[i]);
			}
		}

		var prod_req_dt = $('#m_prod_req_dt').val();
		
		var post_data = "prod_req_dt=" + encodeURIComponent(encodeURIComponent(prod_req_dt));
		post_data += "&grid_data=" + encodeURIComponent(JSON.stringify(grid_data));
		
		
		fnMessageModalConfirm("알림", "수주번호 "+ get_data.order_no + "에 대한 정보를 수정하시겠습니까? ", function(result) {
			if(result) {

				post_url = "/product/auto_cnt_update_organization";
				$.ajax({
					url : post_url,
					type : "POST",
					data : post_data,
					dataType : "JSON",
					success : function (data) {
						if(data.status == "200" && data.result == "정상처리") {
							fnMessageModalAlert("결과", "수정이 완료되었습니다");
							$("#autoInsertModal").modal('hide');
							loadList();
						}else{
							fnMessageModalAlert("결과", "현재 수주번호로 편성된 작업지시가 존재합니다");
						}
					},
					error : function(jqXHR, textStatus, errorThrown) {
						fnMessageModalAlert("결과", "정보를 처리하는데 에러가 발생하였습니다.");
					}
				});
			}
		});
	}
	
</script>

</body>
</html>