CREATE DATABASE ThucTap;
USE ThucTap;

-- Bảng GiangVien
CREATE TABLE GiangVien (
    magv INT PRIMARY KEY,
    hoten VARCHAR(50) NOT NULL,
    luong DECIMAL(10,2) CHECK (luong > 0)
);

-- Bảng SinhVien
CREATE TABLE SinhVien (
    masv INT PRIMARY KEY,
    hoten VARCHAR(50) NOT NULL,
    namsinh INT CHECK (namsinh > 1900),
    quequan VARCHAR(50)
);

-- Bảng DeTai
CREATE TABLE DeTai (
    madt INT PRIMARY KEY,
    tendt VARCHAR(100) NOT NULL,
    kinhphi DECIMAL(12,2) CHECK (kinhphi >= 0),
    NoiThucTap VARCHAR(100)
);

-- Bảng HuongDan
CREATE TABLE HuongDan (
    id INT PRIMARY KEY AUTO_INCREMENT,
    masv INT,
    madt INT,
    magv INT,
    ketqua VARCHAR(20),
    FOREIGN KEY (masv) REFERENCES SinhVien(masv) ON DELETE CASCADE,
    FOREIGN KEY (madt) REFERENCES DeTai(madt),
    FOREIGN KEY (magv) REFERENCES GiangVien(magv)
);

-- Thêm dữ liệu
INSERT INTO GiangVien VALUES 
(1, 'Nguyen Van A', 15000),
(2, 'Tran Thi B', 20000),
(3, 'Le Van C', 18000);

INSERT INTO SinhVien VALUES 
(101, 'Pham Van D', 2000, 'Ha Noi'),
(102, 'Nguyen Thi E', 1999, 'Hai Phong'),
(103, 'Tran Van F', 2001, 'Da Nang');

INSERT INTO DeTai VALUES 
(201, 'CONG NGHE SINH HOC', 500000, 'Vien Sinh Hoc'),
(202, 'TRI TUE NHAN TAO', 700000, 'FPT Software'),
(203, 'HE THONG NHUNG', 300000, 'BKAV');

INSERT INTO HuongDan(masv, madt, magv, ketqua) VALUES
(101, 201, 1, 'Dat'),
(102, 202, 2, 'Tot'),
(103, 203, 3, 'Kha');



SELECT * 
FROM SinhVien sv
WHERE sv.masv NOT IN (SELECT masv FROM HuongDan);

SELECT COUNT(*) AS SoLuong
FROM HuongDan hd
JOIN DeTai dt ON hd.madt = dt.madt
WHERE dt.tendt = 'CONG NGHE SINH HOC';

CREATE VIEW SinhVienInfo AS
SELECT sv.masv, sv.hoten,
       COALESCE(dt.tendt, 'Chưa có') AS tendt
FROM SinhVien sv
LEFT JOIN HuongDan hd ON sv.masv = hd.masv
LEFT JOIN DeTai dt ON hd.madt = dt.madt;

DELIMITER //

CREATE TRIGGER trg_check_namsinh
BEFORE INSERT ON SinhVien
FOR EACH ROW
BEGIN
    IF NEW.namsinh <= 1900 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Năm sinh phải > 1900';
    END IF;
END //

DELIMITER ;

FOREIGN KEY (masv) REFERENCES SinhVien(masv) ON DELETE CASCADE