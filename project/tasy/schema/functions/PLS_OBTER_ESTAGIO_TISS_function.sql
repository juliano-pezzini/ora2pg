-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_estagio_tiss (ie_estagio_p pls_guia_plano.ie_estagio%type) RETURNS bigint AS $body$
DECLARE



/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:   Obter o estagio no padrao tiss de acordo com o estagio da guia.
----------------------------------------------------------------------------------------------------------------------------------------------------
Locais de chamada direta: 
[  ]  Objetos do dicionario [  ] Tasy (Delphi/Java) [ x ] Portal [  ] Relatorios [ ] Outros:
 ----------------------------------------------------------------------------------------------------------------------------------------------------
Pontos de atencao:  SEGUE O DOMINIO 45 DO PADRAO TISS
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*//**
<!-- Dominio 2055 Tasy -->
<!-- 1 - Em auditoria -->
<!-- 2 - Consistido com glosa -->
<!-- 3 - Consistido sem glosa -->
<!-- 4 - Negado -->
<!-- 5 - Autorizado com glosa -->
<!-- 6 - Autorizado sem glosa -->
<!-- 7 - Usuario (aguardando acao) -->
<!-- 8 - Cancelada -->
<!-- 9 - Aguardando autorizacao do contratante -->
<!-- 10 - Autorizado parcialmente -->
<!-- 11 - Auditoria intercambio -->
<!-- 12 - Aguardando autorizacao intercambio -->

<!-- Tabela 45 - Padrao TISS 3.05.00 -->
<!-- 1 - Autorizado-->
<!-- 2 - Em analise-->
<!-- 3 - Negado-->
<!-- 4 - Aguardando justificativa tecnica do solicitante-->
<!-- 5 - Aguardando documentacao do prestador-->
<!-- 6 - Solicitacao cancelada-->
<!-- 7 - Autorizado parcialmente-->
**/
ie_estagio_w pls_guia_plano.ie_estagio%type;


BEGIN
ie_estagio_w := 0;

if   coalesce(ie_estagio_p,0) in (5,6) then
  ie_estagio_w := 1; -- 1 - Autorizado
elsif   coalesce(ie_estagio_p,0) in (1, 2, 3, 7, 9, 11, 12) then
  ie_estagio_w := 2; -- 2 - Em analise
elsif   coalesce(ie_estagio_p,0) in (4) then
  ie_estagio_w := 3; -- 3 - Negado
elsif   coalesce(ie_estagio_p,0) in (8) then
  ie_estagio_w := 6; -- 6 - Solicitacao cancelada
elsif   coalesce(ie_estagio_p,0) in (10) then
  ie_estagio_w := 7; -- 7 - Autorizado parcialmente
end if;

return ie_estagio_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_estagio_tiss (ie_estagio_p pls_guia_plano.ie_estagio%type) FROM PUBLIC;

