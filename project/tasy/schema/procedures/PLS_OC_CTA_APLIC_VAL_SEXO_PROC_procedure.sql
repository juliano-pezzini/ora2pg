-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_oc_cta_aplic_val_sexo_proc ( dados_regra_p pls_tipos_ocor_pck.dados_regra, nr_id_transacao_p pls_oc_cta_selecao_ocor_v.nr_id_transacao%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:  Aplicar a validação de Sexo exclusivo do procedimento em cima das contas ou itens
	que foram filtrados pelos filtros da regra e verificar se os mesmos continuam válidos
	ou não.
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[X]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:

Alterações:
 ------------------------------------------------------------------------------------------------------------------
 jjung OS 601977 10/06/2013 - Criação da procedure.
 ------------------------------------------------------------------------------------------------------------------
 jjung OS 602057 - 18/06/2013

 Alteração:	Retirado o campo dados_filtro_w.ieececao e substituido pelo ie_gera_ocorrencia.

 Motivo:	Foi identificado que a lógica do campo ie_excecao era muito confusa e poderia
	trazer problemas.
 ------------------------------------------------------------------------------------------------------------------
 jjung 29/06/2013

Alteração:	Adicionado parametro nos métodos de atualização dos campos IE_VALIDO e IE_VALIDO_TEMP
	da PLS_TIPOS_OCOR_PCK

Motivo:	Se tornou necessário diferenciar os filtros das validações na hora de realizar esta operação
	para que os filtros de exceção funcionem corretamente.
------------------------------------------------------------------------------------------------------------------
 jjung 25/07/2013

Alteração:	Alterado forma de buscar os procedimentos que estão na tabela de seleção. Também foi alterado
	a forma de verificação do sexo do procedimento para que não considere procedimento nem
	beneficiário com sexo indeterminado.

Motivo:	Foi visto que a ocorrência estava sendo gerada quando o beneficiário ou o procedimento
	tinham o sexo como Indeterminado o que se entende que não é o certo.
------------------------------------------------------------------------------------------------------------------
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
BEGIN
null;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_oc_cta_aplic_val_sexo_proc ( dados_regra_p pls_tipos_ocor_pck.dados_regra, nr_id_transacao_p pls_oc_cta_selecao_ocor_v.nr_id_transacao%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
