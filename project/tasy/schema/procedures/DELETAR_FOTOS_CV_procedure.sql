-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE deletar_fotos_cv () AS $body$
DECLARE


cd_pessoa_fisica_w	bigint;
nr_sequencia_w		bigint;
cont_w			bigint := 0;

C01 CURSOR FOR

SELECT  coalesce(b.cd_pessoa_fisica,0),
	a.nr_sequencia
FROM 	ATENDIMENTO_VISITA_FOTO A, ATENDIMENTO_VISITA B
WHERE	a.nr_seq_atend_visita = b.nr_sequencia
AND		a.dt_atualizacao <= clock_timestamp() - interval '180 days'
OR		((coalesce(a.dt_atualizacao::text, '') = '') AND (a.dt_atualizacao_nrec <= clock_timestamp() - interval '180 days'));




BEGIN

open C01;
loop
fetch C01 into
	cd_pessoa_fisica_w,
	nr_sequencia_w;
EXIT WHEN NOT FOUND; /* apply on C01 */

/*	insert into  log_XXXtasy(
		dt_atualizacao,
		nm_usuario,
		cd_log,
		ds_log)
	values
		(
		sysdate,
		'TASY',
		23,
		'Exclusão da foto da pessoa fisica: ' || cd_pessoa_fisica_w || ', da função : "Controle de Visita"'); */
	delete
	from 	ATENDIMENTO_VISITA_FOTO
	where	nr_sequencia = nr_sequencia_w;

	cont_w	:= cont_w + 1;

	if (cont_w = 1000) then
		commit;
		cont_w	:= 0;
	end if;



end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE deletar_fotos_cv () FROM PUBLIC;

