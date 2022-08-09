-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fin_gv_reprovacao ( nr_seq_pend_aprov_p bigint, ie_tipo_p text, nr_mtvo_reprov_p bigint, ds_mtvo_reprov_p text, nm_usuario_p text) AS $body$
DECLARE


/*
ie_tipo_p indica tipo de aprovação:
A = Reprovação de Adiantamento
D = Reprovação de Despesas
*/
nr_seq_viagem_w		bigint;
cd_pessoa_fisica_w  	varchar(10);
cd_pessoa_aprov_w  	varchar(10);
nm_usuario_viajante_w	varchar(15);
nm_usuario_confirm_w	varchar(15);
nm_usuario_confir_w	varchar(15);
ds_usuario_receb_w	varchar(255);
ds_destino_w		varchar(255);
ds_origem_w		varchar(255);
ds_destino_confirm_w	varchar(255);


BEGIN
select	nr_seq_viagem, cd_pessoa_fisica, cd_pessoa_aprov
into STRICT	nr_seq_viagem_w, cd_pessoa_fisica_w, cd_pessoa_aprov_w
from	fin_gv_pend_aprov
where	nr_sequencia = nr_seq_pend_aprov_p;

if (ie_tipo_p = 'A') then
	begin
	update 	fin_gv_pend_aprov
	set	nm_usuario = nm_usuario_p,
		dt_atualizacao = clock_timestamp(),
		dt_reprov_adia = clock_timestamp(),
		nr_mtvo_reprov_adia = nr_mtvo_reprov_p,
		ds_mtvo_reprov_adia = ds_mtvo_reprov_p,
		ie_situacao_pend = ie_situacao_pend
	where	nr_sequencia = nr_seq_pend_aprov_p;

	update 	via_adiantamento
	set	dt_reprovacao = clock_timestamp(),
		nm_usuario_reprov = nm_usuario_p,
		nr_mtvo_reprov = nr_mtvo_reprov_p
	where	nr_seq_viagem = nr_seq_viagem_w
	and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
	and	coalesce(dt_aprovacao::text, '') = ''
	and	coalesce(dt_reprovacao::text, '') = '';
	end;
elsif (ie_tipo_p = 'D') then
	begin
	update 	fin_gv_pend_aprov
	set	nm_usuario = nm_usuario_p,
		dt_atualizacao = clock_timestamp(),
		dt_reprov_desp = clock_timestamp(),
		nr_mtvo_reprov_desp = nr_mtvo_reprov_p,
		ds_mtvo_reprov_desp = ds_mtvo_reprov_p,
		ie_situacao_pend = ie_situacao_pend
	where	nr_sequencia = nr_seq_pend_aprov_p;

	update 	via_viagem
	set	nm_usuario = nm_usuario_p,
		dt_atualizacao = clock_timestamp(),
		ie_etapa_viagem = 7
	where	nr_sequencia = nr_seq_viagem_w;
	end;
elsif (ie_tipo_p = 'T') then
	begin
	update 	fin_gv_pend_aprov
	set	nm_usuario		= nm_usuario_p,
		dt_atualizacao		= clock_timestamp(),
		dt_aprov_transp		 = NULL,
		dt_reprov_transp	= clock_timestamp(),
		nr_mtvo_reprov_adia	= nr_mtvo_reprov_p,
		ds_mtvo_reprov_adia	= ds_mtvo_reprov_p
	where	nr_sequencia		= nr_seq_pend_aprov_p;

	update 	via_viagem -- Retornar GV para prevista
	set	nm_usuario = nm_usuario_p,
		dt_atualizacao = clock_timestamp(),
		ie_etapa_viagem = 0,
		nm_usuario_confir  = NULL,
		dt_confirmacao  = NULL
	where	nr_sequencia = nr_seq_viagem_w;
	end;
elsif (ie_tipo_p = 'H') then
	begin
	update 	fin_gv_pend_aprov
	set	nm_usuario	= nm_usuario_p,
		dt_atualizacao	= clock_timestamp(),
		dt_reprov_hosp	= clock_timestamp(),
		dt_aprov_hosp	 = NULL,
		nr_mtvo_reprov_adia	= nr_mtvo_reprov_p,
		ds_mtvo_reprov_adia	= ds_mtvo_reprov_p
	where	nr_sequencia	= nr_seq_pend_aprov_p;

	update 	via_viagem -- Retornar GV para prevista
	set	nm_usuario = nm_usuario_p,
		dt_atualizacao = clock_timestamp(),
		ie_etapa_viagem = 0,
		nm_usuario_confir  = NULL,
		dt_confirmacao  = NULL
	where	nr_sequencia = nr_seq_viagem_w;
	end;
elsif (ie_tipo_p = 'R') then
	begin
	update 	fin_gv_pend_aprov
	set	nm_usuario = nm_usuario_p,
		dt_atualizacao = clock_timestamp(),
		dt_reprov_hosp = clock_timestamp(),
		dt_aprov_hosp  = NULL,
		dt_reprov_transp  = NULL,
		dt_aprov_transp  = NULL,
		dt_reprov_gv  = NULL,
		nr_mtvo_reprov_desp = nr_mtvo_reprov_p,
		ds_mtvo_reprov_desp = ds_mtvo_reprov_p,
		ie_situacao_pend = 'RR'
	where	nr_sequencia = nr_seq_pend_aprov_p;

	update	via_relat_desp
	set	dt_aprovacao  = NULL,
		dt_liberacao  = NULL,
		nm_usuario_aprov  = NULL,
		nm_usuario_libera  = NULL
	where	nr_seq_viagem = nr_seq_viagem_w;

	update	via_viagem
	set	nm_usuario = nm_usuario_p,
		dt_atualizacao = clock_timestamp(),
		ie_etapa_viagem = 4
	where	nr_sequencia = nr_seq_viagem_w;
	end;
elsif (ie_tipo_p = 'V') then
	begin
	update 	fin_gv_pend_aprov
	set	nm_usuario	= nm_usuario_p,
		dt_atualizacao	= clock_timestamp(),
		dt_aprov_gv	 = NULL,
		dt_reprov_gv	= clock_timestamp(),
		nr_mtvo_reprov_adia	= nr_mtvo_reprov_p,
		ds_mtvo_reprov_adia	= ds_mtvo_reprov_p,
		ie_situacao_pend	= 'CG'
	where	nr_sequencia	= nr_seq_pend_aprov_p;

	update 	via_viagem -- reprovar viagem
	set	nm_usuario = nm_usuario_p,
		dt_atualizacao = clock_timestamp(),
		ie_etapa_viagem = 9
	where	nr_sequencia = nr_seq_viagem_w;

	select	max(a.nm_usuario)
	into STRICT	nm_usuario_viajante_w
	from	usuario a
	where	a.cd_pessoa_fisica = cd_pessoa_fisica_w;

	select	max(a.nm_usuario_confir)
	into STRICT	nm_usuario_confir_w
	from	via_viagem a
	where	a.nr_sequencia = nr_seq_viagem_w;

	ds_usuario_receb_w := nm_usuario_viajante_w || ',' || nm_usuario_confir_w;

	CALL gerar_comunic_padrao(	clock_timestamp(),
				'Adiantamento da GV: '|| nr_seq_viagem_w || ' Reprovado.',
				'Pessoa Solicitante: ' || substr(obter_nome_usuario(nm_usuario_viajante_w),1,80) || chr(13) || chr(10) ||
				'Confirmada por: ' || obter_nome_usuario(nm_usuario_viajante_w) || chr(13) || chr(10) || chr(13) || chr(10) ||
				'reprovado por: ' || obter_nome_usuario(nm_usuario_p),
				nm_usuario_p, 'N', ds_usuario_receb_w, 'S', null, '', '', '', clock_timestamp(), '', '');

	select 	coalesce(max(ds_email), '') email_origem
	into STRICT 	ds_origem_w
	from 	usuario
	where 	nm_usuario = nm_usuario_p;

	select 	coalesce(max(ds_email), '') email_destino
	into STRICT 	ds_destino_w
	from 	usuario
	where 	nm_usuario = nm_usuario_viajante_w;

	select	coalesce(max(ds_email), '')
	into STRICT	ds_destino_confirm_w
	from	usuario
	where	nm_usuario = nm_usuario_confir_w;

	ds_destino_w := ds_destino_w || ';' || ds_destino_confirm_w;

	CALL enviar_email(	'Adiantamento da GV: '|| nr_seq_viagem_w || ' aprovado.',
			'Pessoa Solicitante: ' || substr(obter_nome_usuario(nm_usuario_viajante_w),1,80) || chr(13) || chr(10) ||
			'Confirmada por: ' || obter_nome_usuario(nm_usuario_confir_w) || chr(13) || chr(10) || chr(13) || chr(10) ||
			'Aprovador por: ' || obter_nome_usuario(nm_usuario_p),ds_origem_w,ds_destino_w,nm_usuario_p,'M');
	end;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fin_gv_reprovacao ( nr_seq_pend_aprov_p bigint, ie_tipo_p text, nr_mtvo_reprov_p bigint, ds_mtvo_reprov_p text, nm_usuario_p text) FROM PUBLIC;
