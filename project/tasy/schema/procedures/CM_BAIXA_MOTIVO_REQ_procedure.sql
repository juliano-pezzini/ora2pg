-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cm_baixa_motivo_req ( nr_requisicao_p bigint, cd_motivo_baixa_p bigint, nm_usuario_p text) AS $body$
DECLARE


qt_item_atend_w			integer;
nr_seq_classif_w			bigint;
ds_setor_requisicao_w		varchar(255);
nm_usuario_requisitante_w		varchar(15);
cd_estabelecimento_w		integer;
nr_seq_item_w			bigint;

c01 CURSOR FOR
	SELECT	b.nr_sequencia
	from	cm_requisicao a,
		cm_requisicao_item b
	where	a.nr_sequencia = b.nr_seq_requisicao
	and 	a.nr_sequencia = nr_requisicao_p
	and	coalesce(b.cd_motivo_baixa::text, '') = ''
	order by b.nr_sequencia;


BEGIN
select	substr(obter_nome_setor(cd_setor_atendimento),1,255),
	substr(obter_usuario_pessoa(cd_pessoa_requisitante),1,15),
	cd_estabelecimento
into STRICT	ds_setor_requisicao_w,
	nm_usuario_requisitante_w,
	cd_estabelecimento_w
from	cm_requisicao
where	nr_sequencia = nr_requisicao_p;

open c01;
loop
fetch c01 into
	nr_seq_item_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	update	cm_requisicao_item
	set	cd_motivo_baixa		= cd_motivo_baixa_p,
		dt_atualizacao		= clock_timestamp(),
		nm_usuario		= nm_usuario_p,
		nm_usuario_atend	= nm_usuario_p
	where	nr_sequencia		= nr_seq_item_w
	and	nr_seq_requisicao	= nr_requisicao_p;
	end;
end loop;
close c01;

select	count(*)
into STRICT	qt_item_atend_w
from	cm_requisicao_item
where	nr_seq_requisicao = nr_requisicao_p
and	coalesce(cd_motivo_baixa,0) = 0;

if (qt_item_atend_w = 0) then
	begin
	update	cm_requisicao
	set	dt_baixa	= clock_timestamp(),
		nm_usuario	= nm_usuario_p
	where	nr_sequencia	= nr_requisicao_p;
	end;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cm_baixa_motivo_req ( nr_requisicao_p bigint, cd_motivo_baixa_p bigint, nm_usuario_p text) FROM PUBLIC;

