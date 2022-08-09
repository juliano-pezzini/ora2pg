-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_atualiza_tela_analise_cta ( nr_seq_analise_p bigint, nr_nivel_p bigint, nr_seq_grupo_p bigint, ie_minha_analise_p text, ie_pendentes_p text, ie_cabecalho_p text, nm_usuario_p text, ie_somente_ocor_p text default 'N', ie_ocultar_canc_p text default 'N', nr_id_transacao_p INOUT bigint DEFAULT NULL, ie_html5_p text default 'N', ie_checados_p text default 'N') AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Chamar as rotinas da package para atualização da tela da análise (gerar tabelas
temporárias.
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[  ]  Objetos do dicionário [ X] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
qt_itens_analise_anterior_w 	integer := 0;
qt_itens_analise_posterior_w	integer := 0;


BEGIN

select count(1)
into STRICT	qt_itens_analise_anterior_w
from	w_pls_analise_item
where	nr_seq_analise = nr_seq_analise_p
and		nr_id_transacao = nr_id_transacao_p;

if (ie_html5_p = 'S') then

  if (ie_cabecalho_p = 'S') then
    nr_id_transacao_p := pls_gerar_w_analise_cabecalho(nr_seq_analise_p, nr_seq_grupo_p, nm_usuario_p, nr_id_transacao_p);
  end if;

  nr_id_transacao_p := pls_consulta_analise_pck.pls_gerar_w_item_analise(nr_seq_analise_p, nr_nivel_p, nr_seq_grupo_p, ie_minha_analise_p, ie_pendentes_p, nm_usuario_p, ie_somente_ocor_p, ie_ocultar_canc_p, nr_id_transacao_p, ie_html5_p);

else

  if (ie_cabecalho_p = 'S') then
    nr_id_transacao_p := pls_gerar_w_analise_cabecalho(nr_seq_analise_p, nr_seq_grupo_p, nm_usuario_p, nr_id_transacao_p);
  else
    nr_id_transacao_p := pls_consulta_analise_pck.pls_gerar_w_item_analise(nr_seq_analise_p, nr_nivel_p, nr_seq_grupo_p, ie_minha_analise_p, ie_pendentes_p, nm_usuario_p, ie_somente_ocor_p, ie_ocultar_canc_p, nr_id_transacao_p, ie_html5_p);
  end if;

end if;

select count(1)
into STRICT	qt_itens_analise_posterior_w
from	w_pls_analise_item
where	nr_seq_analise = nr_seq_analise_p
and		nr_id_transacao = nr_id_transacao_p;

if (ie_checados_p = 'N') then
	if (qt_itens_analise_posterior_w < qt_itens_analise_anterior_w) then
		
		delete from w_pls_analise_selecao_item
		where	nr_seq_analise = nr_seq_analise_p;
		
		update w_pls_analise_item
		set		ie_selecionado = 'N'
		where	nr_seq_analise = nr_seq_analise_p
		and		nr_id_transacao = nr_id_transacao_p;
		
	end if;
end if;
	
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_atualiza_tela_analise_cta ( nr_seq_analise_p bigint, nr_nivel_p bigint, nr_seq_grupo_p bigint, ie_minha_analise_p text, ie_pendentes_p text, ie_cabecalho_p text, nm_usuario_p text, ie_somente_ocor_p text default 'N', ie_ocultar_canc_p text default 'N', nr_id_transacao_p INOUT bigint DEFAULT NULL, ie_html5_p text default 'N', ie_checados_p text default 'N') FROM PUBLIC;
