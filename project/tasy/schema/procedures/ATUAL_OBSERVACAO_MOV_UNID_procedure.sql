-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atual_observacao_mov_unid ( nr_seq_interno_p bigint, ds_observacao_p text, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


ds_erro_w	varchar(10);


BEGIN
begin
update	atend_paciente_unidade
set		ds_observacao	= substr(ds_observacao_p,1,2000)
where	nr_seq_interno	= nr_seq_interno_p;
exception
when others then
		ds_erro_w	:= '';
end;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atual_observacao_mov_unid ( nr_seq_interno_p bigint, ds_observacao_p text, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

