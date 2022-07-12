-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


/*Registro e003: campos adicionais*/

CREATE OR REPLACE PROCEDURE fis_sef_edoc_reg_lfpd05_pck.fis_gerar_reg_e003_edoc () AS $body$
DECLARE


/*Variaveis do procedure*/

nr_seq_fis_sef_edoc_e003_w	fis_sef_edoc_e003.nr_sequencia%type;

c_reg_e003 CURSOR FOR
	SELECT	'PE'	sg_uf,
		ds_lin_nom,
		nr_campo_ini,
		qt_campo
	from (
			SELECT	'E025'	ds_lin_nom,
				'16'	nr_campo_ini,
				'2'	qt_campo
			
			
union all

			select	'E055'	ds_lin_nom,
				'09'	nr_campo_ini,
				'1'	qt_campo
			
			
union all

			select	'E065'	ds_lin_nom,
				'06'	nr_campo_ini,
				'1'	qt_campo
			
			
union all

			select	'E085'	ds_lin_nom,
				'10'	nr_campo_ini,
				'1'	qt_campo
			
			
union all

			select	'E105'	ds_lin_nom,
				'11'	nr_campo_ini,
				'1'	qt_campo
			
			
union all

			select	'E310'	ds_lin_nom,
				'10'	nr_campo_ini,
				'1'	qt_campo
			
			
union all

			select	'E350'	ds_lin_nom,
				'10'	nr_campo_ini,
				'1'	qt_campo
			) alias0;

/*Criação do array com o tipo sendo do cursor eespecificado - c_reg_e003*/

type reg_c_reg_e003 is table of c_reg_e003%RowType;
vetrege003 reg_c_reg_e003;

BEGIN

open c_reg_e003;
loop
fetch c_reg_e003 bulk collect into vetrege003;
	for i in 1 .. vetrege003.Count loop
		begin

		/*Pega a sequencia da taleba fis_sef_edoc_ para o insert*/

		select	nextval('fis_sef_edoc_e003_seq')
		into STRICT	nr_seq_fis_sef_edoc_e003_w
		;

		insert into	fis_sef_edoc_e003(	nr_sequencia,
								dt_atualizacao,
								nm_usuario,
								dt_atualizacao_nrec,
								nm_usuario_nrec,
								cd_reg,
								sg_uf,
								ds_lin_nom,
								nr_campo_ini,
								qt_campo,
								nr_seq_controle
							)
					values (	nr_seq_fis_sef_edoc_e003_w,
					                        clock_timestamp(),
								current_setting('fis_sef_edoc_reg_lfpd05_pck.nm_usuario_w')::usuario.nm_usuario%type,
								clock_timestamp(),
								current_setting('fis_sef_edoc_reg_lfpd05_pck.nm_usuario_w')::usuario.nm_usuario%type,
					                        'E003',
					                        vetrege003[i].sg_uf,
					                        vetrege003[i].ds_lin_nom,
					                        vetrege003[i].nr_campo_ini,
					                        vetrege003[i].qt_campo,
					                        current_setting('fis_sef_edoc_reg_lfpd05_pck.nr_seq_controle_w')::fis_sef_edoc_controle.nr_sequencia%type
							);

		end;
	end loop;
EXIT WHEN NOT FOUND; /* apply on c_reg_e003 */
end loop;
close c_reg_e003;

commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fis_sef_edoc_reg_lfpd05_pck.fis_gerar_reg_e003_edoc () FROM PUBLIC;
