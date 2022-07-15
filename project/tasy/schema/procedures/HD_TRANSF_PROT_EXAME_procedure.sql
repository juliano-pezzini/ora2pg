-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE hd_transf_prot_exame ( cd_pessoa_fisica_p text, cd_unidade_destino_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_protocolo_w	bigint;
nr_seq_prot_exame_w	bigint;
cd_estabelecimento_w	smallint;
ie_possui_exame_w	varchar(1);
ie_tratamento_w		varchar(15);
ie_trat_ativo_w		varchar(15);

C01 CURSOR FOR
	SELECT	nr_sequencia
	from	hd_protocolo_exame
	where 	cd_pessoa_fisica = cd_pessoa_fisica_p
	and	coalesce(dt_fim::text, '') = '';

C02 CURSOR FOR
	SELECT	b.nr_sequencia,
		b.ie_tratamento
	from	hd_prot_exame_padrao b
	where	coalesce(b.ie_situacao,'A') = 'A'
	and	((coalesce(b.cd_estabelecimento::text, '') = '') or (b.cd_estabelecimento = cd_estabelecimento_w))
	and	((coalesce(b.cd_convenio::text, '') = '')
	or 	(b.cd_convenio = (SELECT max(c.cd_convenio)
				from hd_pac_renal_cronico c
				where c.cd_pessoa_fisica = cd_pessoa_fisica_p)))
	and	ie_possui_exame_w = 'S'
	and	coalesce(ie_tratamento::text, '') = '';

C03 CURSOR FOR
	SELECT	ie_tratamento
	from	paciente_tratamento
	where	cd_pessoa_fisica = cd_pessoa_fisica_p
	and	coalesce(dt_final_tratamento::text, '') = '';

C04 CURSOR FOR
	SELECT	b.nr_sequencia,
		b.ie_tratamento
	from	hd_prot_exame_padrao b
	where	coalesce(b.ie_situacao,'A') = 'A'
	and	((coalesce(b.cd_estabelecimento::text, '') = '') or (b.cd_estabelecimento = cd_estabelecimento_w))
	and	((coalesce(b.cd_convenio::text, '') = '')
	or 	(b.cd_convenio = (SELECT max(c.cd_convenio)
				from hd_pac_renal_cronico c
				where c.cd_pessoa_fisica = cd_pessoa_fisica_p)))
	and	ie_possui_exame_w = 'S'
	and	ie_tratamento = ie_trat_ativo_w;


BEGIN
select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
into STRICT	ie_possui_exame_w
from	hd_protocolo_exame
where	cd_pessoa_fisica = cd_pessoa_fisica_p
and	coalesce(dt_fim::text, '') = '';

select	max(cd_estabelecimento)
into STRICT	cd_estabelecimento_w
from	hd_unidade_dialise
where	nr_sequencia = cd_unidade_destino_p;



open C01;
loop
fetch C01 into
	nr_seq_prot_exame_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	update	hd_protocolo_exame
	set	dt_fim = clock_timestamp()
	where	nr_sequencia = nr_seq_prot_exame_w;
	end;
end loop;
close C01;

open C02;
loop
fetch C02 into
	nr_seq_protocolo_w,
	ie_tratamento_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	begin
	insert into hd_protocolo_exame(
		nr_sequencia,
		nr_seq_protocolo,
		dt_atualizacao,
		nm_usuario,
		nm_usuario_nrec,
		dt_atualizacao_nrec,
		cd_pessoa_fisica,
		ie_tratamento)
	values (	nextval('hd_protocolo_exame_seq'),
		nr_seq_protocolo_w,
		clock_timestamp(),
		nm_usuario_p,
		nm_usuario_p,
		clock_timestamp(),
		cd_pessoa_fisica_p,
		ie_tratamento_w);
	end;
end loop;
close C02;


open C03;
loop
fetch C03 into
	ie_trat_ativo_w;
EXIT WHEN NOT FOUND; /* apply on C03 */
	begin

	open C04;
	loop
	fetch C04 into
		nr_seq_protocolo_w,
		ie_tratamento_w;
	EXIT WHEN NOT FOUND; /* apply on C04 */
		begin
		insert into hd_protocolo_exame(
			nr_sequencia,
			nr_seq_protocolo,
			dt_atualizacao,
			nm_usuario,
			nm_usuario_nrec,
			dt_atualizacao_nrec,
			cd_pessoa_fisica,
			ie_tratamento)
		values (	nextval('hd_protocolo_exame_seq'),
			nr_seq_protocolo_w,
			clock_timestamp(),
			nm_usuario_p,
			nm_usuario_p,
			clock_timestamp(),
			cd_pessoa_fisica_p,
			ie_tratamento_w);
		end;
	end loop;
	close C04;

	end;
end loop;
close C03;



commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hd_transf_prot_exame ( cd_pessoa_fisica_p text, cd_unidade_destino_p bigint, nm_usuario_p text) FROM PUBLIC;

