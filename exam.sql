use studentmanagement;

DELIMITER $$
create trigger tg_CheckScore
before insert on Grades
for each row
begin
if NEW.score < 0 then
set NEW.score = 0;
elseif NEW.score >10 then
set NEW.score =10;
end if;
end $$
DELIMITER ;


DELIMITER $$
create procedure insert_student(in student_id char(5),in full_name varchar(50))
begin
    start transaction;
    insert into students(StudentID,FullName)
    values(student_id,full_name);
    update students
    set TotalDebt = 5000000
    where StudentID = student_id;
    commit;
end $$;
DELIMITER ;

DELIMITER $$
create trigger tg_LogGradeUpdate
after update on Grades
for each row
begin
insert into gradelog(StudentID,OldScore,NewScore,ChangeDate)
values(OLD.StudentID,OLD.Score,NEW.Score,now());
end $$
DELIMITER ;

DELIMITER $$
create procedure sp_PayTuition(in student_id char(5))
begin 
DECLARE currentDebt DECIMAL(10,2);
	start transaction;
    update students
    set TotalDebt = TotalDebt - 2000000
    where studentID = student_id;
    select TotalDebt into currentDebt
    from students
    where studentID = student_id;
    if currentDebt < 0 then
    rollback;
    else 
    commit;
    end if;
end $$
DELIMITER ;

DELIMITER $$
create trigger tg_PreventPassUpdate
before update on grades
for each row
begin
if OLD.Score >=4.0 then
signal sqlstate '45000'
set message_text= 'Không được phép sửa điểm';
end if;
end $$
DELIMITER ;

DELIMITER $$
create procedure sp_DeleteStudentGrade (in p_StudentID char(5),in p_SubjectID char(5))
begin
declare currentScore decimal(4,2);
	start transaction;
    SELECT Score INTO currentScore
    FROM Grades
    WHERE StudentID = p_StudentID;

    INSERT INTO GradeLog(StudentID, OldScore, NewScore, ChangeDate)
    VALUES (p_StudentID, OLD.score, NULL, NOW());

    DELETE FROM Grades
    WHERE StudentID = student_id;

    IF ROW_COUNT() = 0 THEN
        ROLLBACK;
    ELSE
        COMMIT;
    END IF;

end $$
DELIMITER ;