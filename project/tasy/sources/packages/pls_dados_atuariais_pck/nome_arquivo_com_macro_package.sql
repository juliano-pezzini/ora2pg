-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_dados_atuariais_pck.nome_arquivo_com_macro ( lote_atuarial_p INOUT lote_atuarial, regra_arquivo_p INOUT regra_arquivo) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Gera o nome do arquivo seguindo a macro informada na regra de geracao

-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[X]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
-------------------------------------------------------------------------------------------------------------------

Pontos de atencao:

	
Alteracoes:
-------------------------------------------------------------------------------------------------------------------

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */


ds_retorno_w	pls_atuarial_arq_regra.ds_arquivo%type;


BEGIN

ds_retorno_w := regra_arquivo_p.ds_arquivo;

-- @MMI -  Mes competencia incio lote

ds_retorno_w := replace(ds_retorno_w, '@MMI', to_char(lote_atuarial_p.dt_inicio_comp, 'MM'));

-- @YYYYI - Ano competencia inicio lote

ds_retorno_w := replace(ds_retorno_w, '@YYYYI', to_char(lote_atuarial_p.dt_inicio_comp, 'YYYY'));

--@MMF - Mes competencia fim lote

ds_retorno_w := replace(ds_retorno_w, '@MMF', to_char(lote_atuarial_p.dt_fim_comp, 'MM'));

--@YYYYF - Ano 

ds_retorno_w := replace(ds_retorno_w, '@YYYYF', to_char(lote_atuarial_p.dt_fim_comp, 'YYYY'));

--@CDANS6

ds_retorno_w := replace(ds_retorno_w, '@CDANS6', substr(trim(both lote_atuarial_p.cd_ans),1,6));


return;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_dados_atuariais_pck.nome_arquivo_com_macro ( lote_atuarial_p INOUT lote_atuarial, regra_arquivo_p INOUT regra_arquivo) FROM PUBLIC;