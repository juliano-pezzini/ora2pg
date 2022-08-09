-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gravar_cid_medicamento ( nr_prescricao_p bigint, nr_sequencia_p bigint, cd_doenca_cid_p text, nm_usuario_p text ) AS $body$
DECLARE

nr_sequencia_w	bigint;


BEGIN

select	nextval('prescr_material_cid_seq')
into STRICT	nr_sequencia_w
;

begin
insert into prescr_material_cid(
		nr_sequencia,
		cd_doenca_cid,
		nr_prescricao,
		nr_sequencia_medic,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec )
values (
		nr_sequencia_w,
		cd_doenca_cid_p,
		nr_prescricao_p,
		nr_sequencia_p,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p );

commit;

exception when others then
	--Ocorreu um erro ao registrar o CID. O código informado pode ser inválido, favor verificar!');
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(261394);
end;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gravar_cid_medicamento ( nr_prescricao_p bigint, nr_sequencia_p bigint, cd_doenca_cid_p text, nm_usuario_p text ) FROM PUBLIC;
