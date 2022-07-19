-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_alt_tp_pessoa_atd ( nr_seq_atendimento_p bigint, ie_tipo_pessoa_novo_p text, cd_localizado_p text, nr_seq_participante_p bigint, nm_contato_p text, nr_telefone_p text, nm_usuario_p text) AS $body$
DECLARE




cd_pf_w		pls_contrato_pagador.cd_pessoa_fisica%type;
cd_cgc_w	pls_contrato_pagador.cd_cgc%type;

BEGIN

--Beneficiário
if (ie_tipo_pessoa_novo_p = 'B' or ie_tipo_pessoa_novo_p = 'BI') then

	update	PLS_ATENDIMENTO
	set	ie_tipo_pessoa  = ie_tipo_pessoa_novo_p,
		cd_pessoa_fisica = ( SELECT cd_pessoa_fisica from pls_segurado where nr_sequencia = cd_localizado_p ),
		coalesce(cd_cgc::text, '') = '',
		nm_contato = nm_contato_p,
		nr_telefone = nr_telefone_p,
		coalesce(nr_seq_contrato::text, '') = '',
		coalesce(nr_seq_pagador::text, '') = '',
		coalesce(nr_seq_prestador::text, '') = '',
		coalesce(nr_seq_congenere::text, '') = '',
		nr_seq_segurado = cd_localizado_p,
		nm_usuario = nm_usuario_p
	where	nr_sequencia = nr_seq_atendimento_p;

--Estipulante
elsif ( ie_tipo_pessoa_novo_p = 'E') then

	select	cd_cgc_estipulante,
		cd_pf_estipulante
	into STRICT	cd_cgc_w,
		cd_pf_w
	from	pls_contrato
	where	nr_sequencia = cd_localizado_p;

	update	pls_atendimento
	set	ie_tipo_pessoa  = ie_tipo_pessoa_novo_p,
		cd_pessoa_fisica = cd_pf_w,
		cd_cgc = cd_cgc_w,
		nm_contato = nm_contato_p,
		nr_telefone = nr_telefone_p,
		nr_seq_contrato = cd_localizado_p,
		nr_seq_pagador  = NULL,
		nr_seq_prestador  = NULL,
		nr_seq_congenere  = NULL,
		nr_seq_segurado  = NULL,
		nm_usuario = nm_usuario_p
	where	nr_sequencia = nr_seq_atendimento_p;

--Não identificado
elsif ( ie_tipo_pessoa_novo_p = 'N') then

	update	PLS_ATENDIMENTO
	set	ie_tipo_pessoa  = ie_tipo_pessoa_novo_p,
		cd_pessoa_fisica  = NULL,
		cd_cgc  = NULL,
		nm_contato = nm_contato_p,
		nr_telefone = nr_telefone_p,
		nr_seq_contrato  = NULL,
		nr_seq_pagador  = NULL,
		nr_seq_prestador  = NULL,
		nr_seq_congenere  = NULL,
		nr_seq_segurado  = NULL,
		nm_usuario = nm_usuario_p
	where	nr_sequencia = nr_seq_atendimento_p;

--Pagador
elsif ( ie_tipo_pessoa_novo_p = 'PG') then

	select	cd_pessoa_fisica,
		cd_cgc
	into STRICT	cd_pf_w,
		cd_cgc_w
	from	pls_contrato_pagador
	where	nr_sequencia = cd_localizado_p;

	update	PLS_ATENDIMENTO
	set	ie_tipo_pessoa  = ie_tipo_pessoa_novo_p,
		cd_pessoa_fisica = cd_pf_w,
		cd_cgc = cd_cgc_w,
		nm_contato = nm_contato_p,
		nr_telefone = nr_telefone_p,
		nr_seq_contrato  = NULL,
		nr_seq_prestador  = NULL,
		nr_seq_pagador = cd_localizado_p,
		nr_seq_congenere  = NULL,
		nr_seq_segurado  = NULL,
		nm_usuario = nm_usuario_p
	where	nr_sequencia = nr_seq_atendimento_p;

--Participante HDMI
elsif ( ie_tipo_pessoa_novo_p = 'PH') then

	update	PLS_ATENDIMENTO
	set	ie_tipo_pessoa  = ie_tipo_pessoa_novo_p,
		cd_pessoa_fisica = mprev_obter_dados_partic(nr_seq_participante_p,clock_timestamp(),'PF'),
		cd_cgc  = NULL,
		nm_contato = nm_contato_p,
		nr_telefone = nr_telefone_p,
		nr_seq_contrato  = NULL,
		nr_seq_pagador  = NULL,
		nr_seq_prestador  = NULL,
		nr_seq_congenere  = NULL,
		nr_seq_segurado  = NULL,
		nm_usuario = nm_usuario_p
	where	nr_sequencia = nr_seq_atendimento_p;

--Pessoa física
elsif ( ie_tipo_pessoa_novo_p = 'P') then

	update	PLS_ATENDIMENTO
	set	ie_tipo_pessoa  = ie_tipo_pessoa_novo_p,
		cd_pessoa_fisica = cd_localizado_p,
		cd_cgc  = NULL,
		nm_contato = nm_contato_p,
		nr_telefone = nr_telefone_p,
		nr_seq_contrato  = NULL,
		nr_seq_pagador  = NULL,
		nr_seq_prestador  = NULL,
		nr_seq_congenere  = NULL,
		nr_seq_segurado  = NULL,
		nm_usuario = nm_usuario_p
	where	nr_sequencia = nr_seq_atendimento_p;

--Prestador
elsif ( ie_tipo_pessoa_novo_p = 'PR') then

	select	cd_pessoa_fisica,
		cd_cgc
	into STRICT	cd_pf_w,
		cd_cgc_w
	from	pls_prestador
	where	nr_sequencia = cd_localizado_p;

	update	PLS_ATENDIMENTO
	set	ie_tipo_pessoa  = ie_tipo_pessoa_novo_p,
		cd_pessoa_fisica = cd_pf_w,
		cd_cgc = cd_cgc_w,
		nm_contato = nm_contato_p,
		nr_telefone = nr_telefone_p,
		nr_seq_contrato  = NULL,
		nr_seq_pagador  = NULL,
		nr_seq_prestador = cd_localizado_p,
		nr_seq_congenere  = NULL,
		nr_seq_segurado  = NULL,
		nm_usuario = nm_usuario_p
	where	nr_sequencia = nr_seq_atendimento_p;


--Pessoa Juridica
elsif ( ie_tipo_pessoa_novo_p = 'PJ') then

	update	PLS_ATENDIMENTO
	set	ie_tipo_pessoa  = ie_tipo_pessoa_novo_p,
		cd_pessoa_fisica  = NULL,
		cd_cgc = cd_localizado_p,
		nm_contato = nm_contato_p,
		nr_telefone = nr_telefone_p,
		nr_seq_contrato  = NULL,
		nr_seq_pagador  = NULL,
		nr_seq_prestador  = NULL,
		nr_seq_congenere  = NULL,
		nr_seq_segurado  = NULL,
		nm_usuario = nm_usuario_p
	where	nr_sequencia = nr_seq_atendimento_p;


--Operadora congênere
elsif ( ie_tipo_pessoa_novo_p = 'OP') then

	update	PLS_ATENDIMENTO
	set	ie_tipo_pessoa  = ie_tipo_pessoa_novo_p,
		cd_pessoa_fisica  = NULL,
		cd_cgc  = NULL,
		nm_contato = nm_contato_p,
		nr_telefone = nr_telefone_p,
		nr_seq_contrato  = NULL,
		nr_seq_pagador  = NULL,
		nr_seq_prestador  = NULL,
		nr_seq_segurado  = NULL,
		nm_usuario = nm_usuario_p,
		nr_seq_congenere = cd_localizado_p
	where	nr_sequencia = nr_seq_atendimento_p;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_alt_tp_pessoa_atd ( nr_seq_atendimento_p bigint, ie_tipo_pessoa_novo_p text, cd_localizado_p text, nr_seq_participante_p bigint, nm_contato_p text, nr_telefone_p text, nm_usuario_p text) FROM PUBLIC;

