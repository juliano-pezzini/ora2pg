-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_hist_atend_texto ( nr_seq_atendimento_p bigint, ie_origem_p text, ds_historico_p text, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


nr_seq_tipo_historico_w		bigint;
ds_historico_w			varchar(4000);
dt_historico_w			timestamp;
nm_evento_w			varchar(50);
nr_seq_evento_w			bigint;
ds_funcao_w			varchar(80);
ie_gerar_hist_w			varchar(2);
qt_atend_w			smallint;


BEGIN

if (pls_obter_se_controle_estab('GA') = 'S') then
	select	max(nr_sequencia)
	into STRICT	nr_seq_tipo_historico_w
	from	pls_tipo_historico_atend
	where	ie_gerado_sistema	= 'S'
	and	ie_situacao		= 'A'
	and (cd_estabelecimento = cd_estabelecimento_p );
else
	select	max(nr_sequencia)
	into STRICT	nr_seq_tipo_historico_w
	from	pls_tipo_historico_atend
	where	ie_gerado_sistema	= 'S'
	and	ie_situacao		= 'A';
end if;

if (coalesce(nr_seq_tipo_historico_w,0)	= 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(261831,'');
		--Histórico gerado pelo sistema não informado, na função OPS - Gestão de atendimento, pasta Cadastros/ Tipos de  histórico !
end if;

select	count(*)
into STRICT	qt_atend_w
from	pls_atendimento
where	coalesce(dt_fim_atendimento::text, '') = ''
and	nr_sequencia = nr_seq_atendimento_p;

if (qt_atend_w > 0) and (coalesce(ds_historico_p,'X') <> 'X') then

	if (ie_origem_p = '1') then
		ds_historico_w := ds_historico_p;
	end if;

	insert	into	pls_atendimento_historico( nr_sequencia, nr_seq_atendimento, ds_historico_long,
		 dt_atualizacao, nm_usuario, dt_atualizacao_nrec,
		 nm_usuario_nrec, nr_seq_tipo_historico, dt_historico,
		 ie_gerado_sistema)
	values (nextval('pls_atendimento_historico_seq'), nr_seq_atendimento_p, ds_historico_w,
		 clock_timestamp(), nm_usuario_p, clock_timestamp(),
		 nm_usuario_p, nr_seq_tipo_historico_w, clock_timestamp(),
		 'S');
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_hist_atend_texto ( nr_seq_atendimento_p bigint, ie_origem_p text, ds_historico_p text, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

