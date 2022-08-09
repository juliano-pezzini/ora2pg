-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_evolucao_vinculo (nr_seq_registro_p bigint, cd_evolucao_p bigint, ie_tipo_item_p text, nr_seq_registro_2_p bigint default null) AS $body$
DECLARE

	
nr_sequencia_w 	bigint;
nm_usuario_w	varchar(15);
qt_reg_w        bigint;
	

BEGIN
if (ie_tipo_item_p <> ' ') then

	qt_reg_w := 0;
	if (ie_tipo_item_p = 'CTR_V') then
		select count(1)
		into STRICT   qt_reg_w
		from   evolucao_paciente_vinculo
		where  cd_evolucao = cd_evolucao_p
		and    ie_tipo_item = 'CTR_V';
	end if;
	
	if (qt_reg_w = 0) then
		nm_usuario_w := coalesce(wheb_usuario_pck.get_nm_usuario,'TASYJOB');
		insert into evolucao_paciente_vinculo(nr_sequencia,
											   dt_atualizacao, 
											   nm_usuario, 
											   dt_atualizacao_nrec, 
											   nr_seq_registro, 
											   ie_tipo_item, 
											   cd_evolucao,
											   nr_seq_registro_2)
										values (nextval('evolucao_paciente_vinculo_seq'),
											   clock_timestamp(),
											   nm_usuario_w,
											   clock_timestamp(),
											   nr_seq_registro_p,
											   ie_tipo_item_p,
											   cd_evolucao_p,
											   nr_seq_registro_2_p);
		commit;
	end if;
end if;

end;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_evolucao_vinculo (nr_seq_registro_p bigint, cd_evolucao_p bigint, ie_tipo_item_p text, nr_seq_registro_2_p bigint default null) FROM PUBLIC;
