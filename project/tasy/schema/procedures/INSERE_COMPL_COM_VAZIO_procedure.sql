-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE insere_compl_com_vazio (cd_pessoa_fisica_p text, nm_usuario_p text, nr_seq_compl_p INOUT bigint) AS $body$
DECLARE


qt_compl_pf_w bigint;
nr_seq_compl_w bigint;


BEGIN

select count(*)
into STRICT	qt_compl_pf_w
from compl_pessoa_fisica
where cd_pessoa_fisica = cd_pessoa_fisica_p
and ie_tipo_complemento = 2;

if (qt_compl_pf_w > 0) then
	select max(nr_sequencia)
	into STRICT	nr_seq_compl_w
	from compl_pessoa_fisica
	where cd_pessoa_fisica = cd_pessoa_fisica_p
	and ie_tipo_complemento = 2;
else
	select coalesce(max(nr_sequencia),0) + 1
	into STRICT	nr_seq_compl_w
	from compl_pessoa_fisica
	where cd_pessoa_fisica = cd_pessoa_fisica_p;

	insert into compl_pessoa_fisica(CD_PESSOA_FISICA,
					NR_SEQUENCIA,
					IE_TIPO_COMPLEMENTO,
					DT_ATUALIZACAO,
					NM_USUARIO)
				values (cd_pessoa_fisica_p,
					nr_seq_compl_w,
					2,
					clock_timestamp(),
					nm_usuario_p);
	commit;
end if;

nr_seq_compl_p := nr_seq_compl_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE insere_compl_com_vazio (cd_pessoa_fisica_p text, nm_usuario_p text, nr_seq_compl_p INOUT bigint) FROM PUBLIC;

