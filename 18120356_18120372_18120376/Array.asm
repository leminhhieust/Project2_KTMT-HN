
.data
	xuat_baitap1: 		.asciiz "********** Mang so nguyen **********\n"
	xuat_menu: 		.asciiz "\n            ---Menu---    \n***********************************\n*Nhap 1 de xuat mang              *\n*Nhap 2 de tinh tong              *\n*Nhap 3 de liet ke so nguyen to   *\n*Nhap 4 de tim gia tri lon nhat   *\n*Nhap 5 de tim gia tri x          *\n*Nhap 0 de thoat chuong trinh     *\n***********************************\n"	
	xuat_nhapchucnang: 	.asciiz "Nhap: "
	xuat_nhap: 		.asciiz "Nhap so luong phan tu (0<n<1000):  "
	xuat_loi: 		.asciiz "Ban da nhap sai so luong phan tu (0<n<1000) !!!\n"
	xuat_danhsach: 		.asciiz "Danh sach cac phan tu trong mang !!! \n"
	xuat_tong: 		.asciiz "Tong cac phan tu trong mang : "
	xuat_nguyento: 		.asciiz "Danh sach cac so nguyen to !!! \n"
	xuat_lonnhat: 		.asciiz "Gia tri lon nhat trong mang: "
	xuat_x: 		.asciiz "Nhap x: "
	xuat_vitrix: 		.asciiz "Vi tri cua cac phan tu co gia tri x !!! \n"
	xuat_khongcophantu: 	.asciiz "Khong co phan tu nao trong mang co gia tri x !!! \n"
	xuat_thoatchuongtrinh: 	.asciiz "Ban da thoat chuong trinh !!! \nTam biet !!!"
	vitriphantu: 		.asciiz "Phan tu thu "
	phancach: 		.asciiz ": "
	khoangtrang: 		.asciiz " "
	xuongdong: 		.asciiz "\n"
	mang: 			.word 1000
.text
	la $a0,xuat_baitap1
	li $v0,4
	syscall
main:
	la $a0,xuat_nhap
	li $v0,4
	syscall
	li $v0,5
	syscall
	move $s0,$v0     #s0 : so luong phan tu
	blt $s0,1,Loi    #soluong < 1 => Loi
	bgt $s0,999,Loi  #soluong > 999 => Loi
	la $a0,mang      #a0: dia chi cua mang 
	move $a1,$s0   	#a1: so luong phan tu
	jal Nhap
	j Lap

Lap:	  #Lap den khi nao nguoi dung nhap 0 de thoat chuong trinh
	la $a0,xuat_menu      #xuat menu
	li $v0,4
	syscall
	la $a0,xuat_nhapchucnang      #xuat Nhap:
	li $v0,4
	syscall
	la $v0,5                     #Nguoi dung nhap so
	syscall
	la $a0,mang           #cap nhat lai a0(mang)
	move $s7,$v0          #s7 la gia tri luu so nguoi nhap de vao tung chuc nang
	jal Xuat              #Vo chuc nang xuat mang
	jal Tong              #Vo chuc nang tinh tong
	jal Nguyento          #Vo chuc nang xuat cac so nguyen to
	jal Lonnhat           #Vo chuc nang tim so lon nhat
	jal X                 #Vo chuc nang tim so X
	jal exit              #Vo chuc nang thoat chuong trinh
	j Lap

Thoatham:   #Ham dieu kien nhay ra khoi chuc nang khi so nguoi dung nhap khac voi dieu kien
	jr $ra		

# Nhap gia tri phan tu trong mang (Nhap)
Nhap:
	move $s0,$a0    #s0: mang
	move $s1,$a1    #s1: so luong phan tu
	li $t0,0
	li $t1,0
Nhap_dieukien:
	slt $t0,$t1,$s1    #Neu t1 < s1 (s1 so luong phan tu) => t0 = 1 
	beq $t0,1,Nhap_lap #Neu t0  = 1 thi nhay toi Nhap_lap
	la $a0,mang        #cap nhat lai a0(mang)
	jr $ra
Nhap_lap:
	la $a0,vitriphantu   #In Phan tu thu
	li $v0,4
	syscall
	addi $a0,$t1,1       #Thu tu phan tu
	li $v0,1
	syscall
	la $a0,phancach      #In :
	li $v0,4
	syscall
	li $v0,5     	  #Nhap gia tri phan tu
	syscall
	sw $v0,($s0)
	addi $s0,$s0,4    #Tang vi tri trong mang them 1
	addi $t1,$t1,1    #Tang bien dem them 1 
	j Nhap_dieukien   # Lap lai Nhap_dieukien de kiem tra xem du phan tu chua
Loi:    # Thong bao cho nguoi dung da nhap sai so luong phan tu va nhap lai 
	la $a0,xuat_loi
	li $v0,4
	syscall
	j main

# Cac ham chuc nang 
#Xuat cac gia tri trong mang(Xuat)
Xuat:
	bne $s7,1,Thoatham  #s7 la so nguoi dung nhap vao de thuc hien chuc nang, neu khong dung thi nhay ra khoi ham
	move $s0,$a0
	move $s1,$a1
	li $t0,0
	li $t1,0
	la $a0,xuat_danhsach
	li $v0,4
	syscall
Xuat_dieukien:
	slt $t0,$t1,$s1    #Neu t1 < s1 (s1 so luong phan tu) => t0 = 1 
	beq $t0,1,Xuat_lap #Neu t0  = 1 thi nhay toi Xuat_lap
	la $a0,xuongdong   #xuong dong
	li $v0,4
	syscall
	la $a0,mang     #cap nhat lai a0(mang)
	j Lap           #thoat ra khoi ham
Xuat_lap:
	li $v0,1
	lw $a0,($s0)    #Gia tri phan tu
	syscall 
	la $a0,khoangtrang
	li $v0,4
	syscall
	addi $s0,$s0,4    #Tang vi tri trong mang them 1
	addi $t1,$t1,1    #Tang bien dem them 1 
	j Xuat_dieukien   # Lap lai Xuat_dieukien de kiem tra xem du phan tu chua

#Tinh tong cac phan tu(Tong)
Tong:
	bne $s7,2,Thoatham  #s7 la so nguoi dung nhap vao de thuc hien chuc nang, neu khong dung thi nhay ra khoi ham
	move $s0,$a0
	move $s1,$a1
	li $t0,0
	li $t1,0
	li $s2,0           # Khoi tao tong = 0
Tong_dieukien:
	slt $t0,$t1,$s1       #Neu t1 < s1 (s1 so luong phan tu) => t0 = 1 
	beq $t0,1,Tong_lap   #Neu t0  = 1 thi nhay toi Tong_lap
	la $a0,xuat_tong     #Xuat xuat_tong
	li $v0,4
	syscall 
	add $a0,$s2,$zero    #in tong cac phan tu
	li $v0,1
	syscall
	la $a0,xuongdong     #xuong dong
	li $v0,4
	syscall
	la $a0,mang     #cap nhat lai a0(mang)
	
	j Lap          #thoat ra khoi ham
Tong_lap:
	lw $t2,($s0)     #gan gia tri phan tu cua mang vao t2
	addu $s2,$s2,$t2  # tong = tong + t2
	
	addi $s0,$s0,4   #Tang vi tri trong mang them 1
	addi $t1,$t1,1   #Tang bien dem them 1
	j Tong_dieukien  #Nhay len Tong_dieukien de kiem tra
	

#Danh sach cac so nguyen to 
Nguyento:
	bne $s7,3,Thoatham  #s7 la so nguoi dung nhap vao de thuc hien chuc nang, neu khong dung thi nhay ra khoi ham
	move $s0,$a0
	move $s1,$s1
	li $t0,0
	li $t1,0
	la $a0,xuat_nguyento
	li $v0,4
	syscall
	li $t5,0          #t5: bien dem
	li $t3,2          #phan tu chay trong vong for kiem tra so nguyen to
	lw $s2,($s0)
Nguyento_dieukienlap:
	slt $t0,$t1,$s1
	beq $t0,1,Nguyento_lap
	la $a0,mang
	j Lap             #Thoat khoi ham
Nguyento_lap:
	slt $t4,$t3,$s2
	beq $t4,1,Nguyento_kiemtradu
	beq $t5,0,Nguyento_in          #dieu kien de in ra so nguyen to
	addi $s0,$s0,4
	addi $t1,$t1,1
	li $t5,0           #Cap nhat lai bien dem
	li $t3,2           #Cap nhat lai bien chay
	lw $s2,($s0)       #Cap nhat lai gia tri can kiem tra
	j Nguyento_dieukienlap
Nguyento_kiemtradu:
	div $s2,$t3
	mfhi $s3              #kiem tra du
	beq $s3,0,Nguyento_tangbien
	addi $t3,$t3,1        #tang bien dem trong vong for
	j Nguyento_lap
Nguyento_tangbien:
	addi $t5,$t5,1
	addi $t3,$t3,1        #tang bien dem trong vong for
	j Nguyento_lap
Nguyento_in:            #in so nguyen to
	blt $s2,2,Nguyento_hai   #kiem tra xem no co nho hon 2 hay khong
	move $a0,$s2
	li $v0,1
	syscall
	la $a0,khoangtrang
	li $v0,4
	syscall
	addi $s0,$s0,4
	addi $t1,$t1,1 
	li $t5,0           #Cap nhat lai bien dem
	li $t3,2           #Cap nhat lai bien chay
	lw $s2,($s0)       #Cap nhat lai gia tri can kiem tra
	j Nguyento_dieukienlap   #Quay lai dieu kien
Nguyento_hai:         #kiem tra xem no co nho hon 2 hay khong
	addi $s0,$s0,4
	addi $t1,$t1,1 
	li $t5,0           #Cap nhat lai bien dem
	li $t3,2           #Cap nhat lai bien chay
	lw $s2,($s0)       #Cap nhat lai gia tri can kiem tra
	j Nguyento_dieukienlap   #Quay lai dieu kien
	
#Tim so lon nhat trong mang
Lonnhat:
	bne $s7,4,Thoatham  #s7 la so nguoi dung nhap vao de thuc hien chuc nang, neu khong dung thi nhay ra khoi ham
	move $s0,$a0
	move $s1,$a1
	li $t0,0
	li $t1,0
	lw $t2,($s0)    #gan gia tri lon nhat bang phan tu dau tien trong mang
	la $a0,xuat_lonnhat
	li $v0,4
	syscall
	
Lonnhat_dieukien:
	slt $t0,$t1,$s1 #Neu t1 < s1 (s1 so luong phan tu) => t0 = 1 
	beq $t0,1,Lonnhat_lap #Neu t0  = 1 thi nhay toi Tong_lap
	move $a0,$t2
	li $v0,1
	syscall
	la $a0,xuongdong     #xuong dong
	li $v0,4
	syscall
	la $a0,mang          #gan lai mang cho a0
	jr $ra               #thoat ra khoi ham 
Lonnhat_lap:
	lw $s2,($s0)
	blt $t2,$s2,Lonnhat_hientai #neu t2 nho hon s2 thi xuong Lonnhat_hientai de gan lai gia tri lon nhat
	addi $s0,$s0,4              #tang vi tri trong mang len 1
	addi $t1,$t1,1              #tang bien dem them 1
	j Lonnhat_dieukien
Lonnhat_hientai:      #ham nay nhay vao khi co gia tri lon hon gia tri lon nhat hien tai
	move $t2,$s2
	addi $s0,$s0,4              #tang vi tri trong mang len 1
	addi $t1,$t1,1              #tang bien dem them 1
	j Lonnhat_dieukien

#Tim vi tri cua x do nguoi dung nhap vao
X:
	bne $s7,5,Thoatham  #s7 la so nguoi dung nhap vao de thuc hien chuc nang, neu khong dung thi nhay ra khoi ham
	addi $sp,$sp,-8
	sw $ra,4($sp)
	move $s0,$a0
	move $s1,$a1
	li $t0,0
	li $t1,0
	la $a0,xuat_x
	li $v0,4
	syscall
	li $v0,5             #Nhap gia tri x
	syscall
	move $t2,$v0         #gan gia tri x cho t2
	la $a0,xuat_vitrix   #Xuat xuat_vitrix
	li $v0,4
	syscall
	li $t3,0             #khoi tao bien t3=0 la so luong phan tu co gia tri x

X_dieukien:
	slt $t0,$t1,$s1 	#Neu t1 < s1 (so luong phan tu) => t0 = 1
	beq $t0,1,X_lap
	jal X_khongcophantunao  #In ra neu khong co phan tu nao thoa x
	la $a0,mang
	lw $ra,4($sp)
	addi $sp,$sp,8
	jr $ra          	#thoat khoi ham
	
	
X_lap:
	lw $s2,($s0)
	beq $t2,$s2,X_invitri  #Neu gia tri t2 bang voi s2 thi in ra
	addi $s0,$s0,4         #Tang vi tri trong mang
	addi $t1,$t1,1         #Tang bien dem
	j X_dieukien
X_invitri: 
	move $a0,$t1
	li $v0,1
	syscall
	la $a0,khoangtrang
	li $v0,4
	syscall
	addi $s0,$s0,4         #Tang vi tri trong mang
	addi $t1,$t1,1         #Tang bien dem
	addi $t3,$t3,1         #Tang so luong phan tu co gia tri x them 1
	j X_dieukien
X_khongcophantunao:      #kiem tra dieu kien co phan tu nao khong
	beq $t3,0,X_inkhongcophantunao
	jr $ra
X_inkhongcophantunao: 	#in ra thong bao khong co phan tu nao thoa x
	la $a0,xuat_khongcophantu
	li $v0,4
	addi $t3,$t3,1   #tang len de khong bi lap lai
	syscall
	j X_khongcophantunao
	
exit:
	bne $s7,0,Thoatham  		#s7 la so nguoi dung nhap vao de thuc hien chuc nang, neu khong dung thi nhay ra khoi ham
	la $a0,xuat_thoatchuongtrinh    #Xuat string thoat chuong trinh
	li $v0,4
	syscall
	li $v0,10
	syscall
