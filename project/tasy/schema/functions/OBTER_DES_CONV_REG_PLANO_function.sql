-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_des_conv_reg_plano ( ie_regra_p bigint) RETURNS varchar AS $body$
DECLARE


ie_retorno_w			varchar(255);

/*
1 - Bloqueio atendimento
2 - Bloqueio execucao
3 - Libera c/ autor. (consiste na execucao e glosa particular)
4 - Liberado
5 - Bloqueia prescricao
6 - Libera c/ autor. (consiste na conta)
7 - Executa somente apos autorizado
8 - Sem cobertura/glosa particular
9 - Bloqueia solicitacao de exames no PEP
*/
BEGIN
        if (ie_regra_p = 1) then
                ie_retorno_w := substr(wheb_mensagem_pck.get_texto(1167630),1,255);
        elsif (ie_regra_p = 2) then
                ie_retorno_w := substr(wheb_mensagem_pck.get_texto(1167631),1,255);
        elsif (ie_regra_p = 3) then
                ie_retorno_w := substr(wheb_mensagem_pck.get_texto(1167633),1,255);
        elsif (ie_regra_p = 4) then
                ie_retorno_w := substr(wheb_mensagem_pck.get_texto(1167634),1,255);
        elsif (ie_regra_p = 5) then
                ie_retorno_w := substr(wheb_mensagem_pck.get_texto(1167635),1,255);
        elsif (ie_regra_p = 6) then
                ie_retorno_w := substr(wheb_mensagem_pck.get_texto(1167636),1,255);
        elsif (ie_regra_p = 7) then
                ie_retorno_w := substr(wheb_mensagem_pck.get_texto(1167637),1,255);
        elsif (ie_regra_p = 8) then
                ie_retorno_w := substr(wheb_mensagem_pck.get_texto(1167638),1,255);
        elsif (ie_regra_p = 9) then
                ie_retorno_w := substr(wheb_mensagem_pck.get_texto(1204327),1,255);
        end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_des_conv_reg_plano ( ie_regra_p bigint) FROM PUBLIC;

