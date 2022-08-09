-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ageint_check_list_confirmacao (nr_seq_agenda_int_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


		
nr_seq_proc_interno_w		bigint;
ie_gerar_check_list_w		varchar(1);	
nr_seq_ageint_check_list_w	bigint;
ie_gerado_w			varchar(1);
nr_seq_item_w			bigint;
nr_seq_proc_int_adic_w		bigint;
cd_especialidade_w		agenda_integrada_item.cd_especialidade%type;
		
C01 CURSOR FOR
	SELECT	nr_seq_proc_interno,
		nr_sequencia,
		cd_especialidade
	from	agenda_integrada_item
	where	nr_seq_agenda_int = nr_seq_agenda_int_p
	order by 1;	

C02 CURSOR FOR
	SELECT	nr_seq_proc_interno
	from	ageint_exame_adic_item
	where	nr_seq_item = nr_seq_item_w
	order by 1;		
			

BEGIN

open C01;
loop
fetch C01 into	
	nr_seq_proc_interno_w,
	nr_seq_item_w,
	cd_especialidade_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	ie_gerar_check_list_w	:= substr(ageint_obter_se_proc_check(nr_seq_proc_interno_w,nr_seq_agenda_int_p, cd_estabelecimento_p, cd_especialidade_w),1,1);
				
	if (ie_gerar_check_list_w = 'S') then
		
		select	nextval('ageint_check_list_paciente_seq')
		into STRICT	nr_seq_ageint_check_list_w
		;
				
		insert into ageint_check_list_paciente(nr_sequencia,
							nr_seq_ageint,
							dt_atualizacao,
							nm_usuario,
							ie_tipo_check_list)
						values (nr_seq_ageint_check_list_w,
							nr_seq_agenda_int_p,
							clock_timestamp(),	
							nm_usuario_p,
							'I');
									
					commit;
								
		CALL Ageint_Gerar_Check_List(nr_seq_ageint_check_list_w,nr_seq_proc_interno_w,nr_seq_agenda_int_p,nm_usuario_p, cd_estabelecimento_p, cd_especialidade_w);

	end if;
	
	open C02;
	loop
	fetch C02 into	
	nr_seq_proc_int_adic_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		ie_gerar_check_list_w	:= substr(ageint_obter_se_proc_check(nr_seq_proc_int_adic_w,nr_seq_agenda_int_p, cd_estabelecimento_p),1,1);
				
		if (ie_gerar_check_list_w = 'S') then
		
		select	nextval('ageint_check_list_paciente_seq')
		into STRICT	nr_seq_ageint_check_list_w
		;
				
		insert into ageint_check_list_paciente(nr_sequencia,
							nr_seq_ageint,
							dt_atualizacao,
							nm_usuario,
							ie_tipo_check_list)
						values (nr_seq_ageint_check_list_w,
							nr_seq_agenda_int_p,
							clock_timestamp(),	
							nm_usuario_p,
							'I');
									
					commit;
								
		CALL Ageint_Gerar_Check_List(nr_seq_ageint_check_list_w,nr_seq_proc_int_adic_w,nr_seq_agenda_int_p,nm_usuario_p, cd_estabelecimento_p);

		end if;
		end;
	end loop;
	close C02;
	end;
end loop;
close C01;


ie_gerado_w := Ageint_checklist_agend_conv(nr_seq_agenda_int_p, nm_usuario_p, cd_estabelecimento_p, ie_gerado_w);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ageint_check_list_confirmacao (nr_seq_agenda_int_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
