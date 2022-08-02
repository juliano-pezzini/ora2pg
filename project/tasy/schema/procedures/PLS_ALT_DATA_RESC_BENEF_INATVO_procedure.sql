-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_alt_data_resc_benef_inatvo ( nr_seq_contrato_p bigint, dt_rescisao_contr_p timestamp, dt_limite_utili_p timestamp, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
Atualizar a data de rescisoes dos beneficiarios e pagadores que tem rescisao maior que a rescisao do contrato
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[ X ]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atencao:
Nao colocar commit na rotina
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ie_situacao_atend_w	varchar(10);

C01 CURSOR FOR
	SELECT	nr_sequencia nr_seq_segurado,
		dt_limite_utilizacao,
		dt_rescisao,
		pls_obter_se_benef_remido(nr_sequencia, dt_rescisao_contr_p) ie_remido
	from	pls_segurado
	where	nr_seq_contrato		= nr_seq_contrato_p
	and	(dt_rescisao IS NOT NULL AND dt_rescisao::text <> '')
	and	trunc(dt_rescisao,'dd')	> trunc(dt_rescisao_contr_p,'dd');

C02 CURSOR FOR
	SELECT	nr_sequencia nr_seq_pagador,
		dt_rescisao,
		(	SELECT	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
			from	pls_segurado x
			where	x.nr_seq_pagador	= a.nr_sequencia
			and	pls_obter_se_benef_remido(x.nr_sequencia, dt_rescisao_contr_p) = 'S') ie_remido
	from	pls_contrato_pagador a
	where	a.nr_seq_contrato		= nr_seq_contrato_p
	and	(a.dt_rescisao IS NOT NULL AND a.dt_rescisao::text <> '')
	and	trunc(a.dt_rescisao,'dd')	> trunc(dt_rescisao_contr_p,'dd');

BEGIN

for r_c01_w in C01 loop
	begin
	if (r_c01_w.ie_remido = 'N') then
		-- Caso a data limite de utilizacao foi maior que a data atual, entao o sistema deve deixar a situacao de atendimento apta
		if (dt_limite_utili_p > clock_timestamp()) then
			ie_situacao_atend_w	:= 'A';
		elsif (dt_limite_utili_p <= clock_timestamp()) then
			ie_situacao_atend_w	:= 'I';
		end if;
		
		update	pls_segurado
		set	dt_limite_utilizacao	= dt_limite_utili_p,
			dt_rescisao		= dt_rescisao_contr_p,
			dt_atualizacao		= clock_timestamp(),
			nm_usuario		= nm_usuario_p,
			ie_situacao_atend	= ie_situacao_atend_w
		where	nr_sequencia		= r_c01_w.nr_seq_segurado;
		
		CALL pls_gerar_segurado_historico(
			r_c01_w.nr_seq_segurado, '15', clock_timestamp(),
			'De: ' || to_char(r_c01_w.dt_limite_utilizacao,'dd/mm/rrrr') || ' para ' || to_char(dt_limite_utili_p,'dd/mm/rrrr'), 'pls_alt_data_resc_benef_inatvo', null,
			null, null, null,
			clock_timestamp(), null, null,
			null, null, null,
			null, nm_usuario_p, 'N');
		
		CALL pls_gerar_segurado_historico(
			r_c01_w.nr_seq_segurado, '19', clock_timestamp(),
			'De: ' || to_char(r_c01_w.dt_rescisao,'dd/mm/rrrr') || ' para ' || to_char(dt_rescisao_contr_p,'dd/mm/rrrr'), 'pls_alt_data_resc_benef_inatvo', null,
			null, null, null,
			clock_timestamp(), null, null,
			null, null, null,
			null, nm_usuario_p, 'N');
	end if;
	end;
end loop; --C01
for r_c02_w in C02 loop
	begin
	if (r_c02_w.ie_remido = 'N') then
		update	pls_contrato_pagador
		set	dt_rescisao		= dt_rescisao_contr_p,
			dt_atualizacao		= clock_timestamp(),
			nm_usuario		= nm_usuario_p
		where	nr_sequencia		= r_c02_w.nr_seq_pagador;
		
		insert	into	pls_pagador_historico(	nr_sequencia, nr_seq_pagador, cd_estabelecimento,
				dt_atualizacao, nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
				dt_historico, ds_titulo, ds_historico,
				nm_usuario_historico, ie_tipo_historico, ie_origem)
			values (	nextval('pls_pagador_historico_seq'), r_c02_w.nr_seq_pagador, cd_estabelecimento_p,
				clock_timestamp(), nm_usuario_p, clock_timestamp(), nm_usuario_p,
				clock_timestamp(), wheb_mensagem_pck.get_texto(1105435), wheb_mensagem_pck.get_texto(1105436,'DT_RESC_ANT='||to_char(r_c02_w.dt_rescisao,'dd/mm/rrrr')||';DT_RESCISAO='||to_char(dt_rescisao_contr_p,'dd/mm/rrrr')),
				nm_usuario_p, 'S', 'GC');
	end if;
	end;
end loop; --C02
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_alt_data_resc_benef_inatvo ( nr_seq_contrato_p bigint, dt_rescisao_contr_p timestamp, dt_limite_utili_p timestamp, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

