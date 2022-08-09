-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_consist_lim_ocorr_req_guia ( nr_seq_segurado_p bigint, nr_seq_requisicao_p bigint, nr_seq_guia_p bigint, ie_tipo_intercambio_p text, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
Consistir liminar ocorrência requisição ou guia
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[ X]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
nr_seq_auditoria_w		bigint;
nr_seq_regra_liminar_w		bigint;
ie_utiliza_nivel_w		varchar(10);


BEGIN

if (nr_seq_guia_p IS NOT NULL AND nr_seq_guia_p::text <> '') then
	nr_seq_regra_liminar_w := pls_gerar_ocorr_liminar_guia(nr_seq_segurado_p, null, nr_seq_guia_p, nm_usuario_p, nr_seq_regra_liminar_w);

	begin
	select	nr_sequencia
	into STRICT	nr_seq_auditoria_w
	from	pls_auditoria
	where	nr_seq_guia	= nr_seq_guia_p;
	exception
	when others then
		nr_seq_auditoria_w	:= null;
	end;

	if (nr_seq_regra_liminar_w IS NOT NULL AND nr_seq_regra_liminar_w::text <> '') and (nr_seq_auditoria_w IS NOT NULL AND nr_seq_auditoria_w::text <> '') and (coalesce(ie_tipo_intercambio_p,'X') <> 'I') then
		-- OS - 421626 - Rotina para gerar as ocorrências e glosas na tabela "pls_analise_ocor_glosa_aut"
		ie_utiliza_nivel_w := pls_obter_se_uti_nivel_lib_aut(cd_estabelecimento_p);
		if (ie_utiliza_nivel_w = 'S') then
			CALL pls_gerar_ocor_glosa_aud_limi(nr_seq_auditoria_w, 0, nr_seq_guia_p, nr_seq_regra_liminar_w, nm_usuario_p);
		end if;
	end if;
elsif (nr_seq_requisicao_p IS NOT NULL AND nr_seq_requisicao_p::text <> '') then
	nr_seq_regra_liminar_w := pls_gerar_ocorr_liminar_judic(	nr_seq_segurado_p, null, nr_seq_requisicao_p, nm_usuario_p, nr_seq_regra_liminar_w, cd_estabelecimento_p);

	begin
	select	nr_sequencia
	into STRICT	nr_seq_auditoria_w
	from	pls_auditoria
	where	nr_seq_requisicao	= nr_seq_requisicao_p;
	exception
	when others then
		nr_seq_auditoria_w	:= null;
	end;

	if (nr_seq_regra_liminar_w IS NOT NULL AND nr_seq_regra_liminar_w::text <> '') and (nr_seq_auditoria_w IS NOT NULL AND nr_seq_auditoria_w::text <> '')  and (coalesce(ie_tipo_intercambio_p,'X') <> 'I') then
		-- OS - 421626 - Rotina para gerar as ocorrências e glosas na tabela "pls_analise_ocor_glosa_aut"
		ie_utiliza_nivel_w	:= pls_obter_se_uti_nivel_lib_aut(cd_estabelecimento_p);

		if (ie_utiliza_nivel_w = 'S') then
			CALL pls_gerar_ocor_glosa_aud_limi(	nr_seq_auditoria_w,
							nr_seq_requisicao_p,
							0,
							nr_seq_regra_liminar_w,
							nm_usuario_p);
		end if;
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_consist_lim_ocorr_req_guia ( nr_seq_segurado_p bigint, nr_seq_requisicao_p bigint, nr_seq_guia_p bigint, ie_tipo_intercambio_p text, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
