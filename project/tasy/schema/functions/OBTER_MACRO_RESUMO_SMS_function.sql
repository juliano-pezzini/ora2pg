-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_macro_resumo_sms () RETURNS varchar AS $body$
DECLARE


ds_retorno_w varchar(2000);


BEGIN

ds_retorno_w :=  replace(wheb_mensagem_pck.get_texto(796798), '@paciente', obter_traducao_macro_pront('@paciente',869)) ||CHR(10)||
     replace(wheb_mensagem_pck.get_texto(796801), '@protocoloagenda', obter_traducao_macro_pront('@protocoloagenda',869)) ||CHR(10)||
     replace(wheb_mensagem_pck.get_texto(796805), '@horario', obter_traducao_macro_pront('@horario',869)) ||CHR(10)||
     replace(wheb_mensagem_pck.get_texto(796806), '@item', obter_traducao_macro_pront('@item',869)) ||CHR(10)||
     replace(wheb_mensagem_pck.get_texto(796807), '@estab', obter_traducao_macro_pront('@estab',869)) ||CHR(10)||
     replace(wheb_mensagem_pck.get_texto(796808), '@primeiro_horario', obter_traducao_macro_pront('@primeiro_horario',869)) ||CHR(10)||
     replace(wheb_mensagem_pck.get_texto(796809), '@especialidade', obter_traducao_macro_pront('@especialidade',869)) ||CHR(10)||
     replace(wheb_mensagem_pck.get_texto(796811), '@medico_agenda', obter_traducao_macro_pront('@medico_agenda',869)) ||CHR(10)||
     replace(wheb_mensagem_pck.get_texto(796812), '@medico_req', obter_traducao_macro_pront('@medico_req',869)) ||CHR(10)||
     replace(wheb_mensagem_pck.get_texto(796813), '@medico_req_crm', obter_traducao_macro_pront('@medico_req_crm',869)) ||CHR(10)||
     replace(wheb_mensagem_pck.get_texto(796814), '@medico_exec', obter_traducao_macro_pront('@medico_exec',869)) ||CHR(10)||
     replace(wheb_mensagem_pck.get_texto(796820), '@medico_exec_crm', obter_traducao_macro_pront('@medico_exec_crm',869)) ||CHR(10)||
     replace(wheb_mensagem_pck.get_texto(796821), '@protocolo_consulta', obter_traducao_macro_pront('@protocolo_consulta',869)) ||CHR(10)||
     replace(wheb_mensagem_pck.get_texto(796823), '@primeiro_nome_medico', obter_traducao_macro_pront('@primeiro_nome_medico',869)) ||CHR(10)||
     replace(wheb_mensagem_pck.get_texto(796824), '@agenda', obter_traducao_macro_pront('@agenda',869)) ||CHR(10)||
     replace(wheb_mensagem_pck.get_texto(796826), '@setor', obter_traducao_macro_pront('@setor',869)) ||CHR(10)||
     replace(wheb_mensagem_pck.get_texto(796829), '@dt_dia_mes', obter_traducao_macro_pront('@dt_dia_mes',869)) ||CHR(10)||
     replace(wheb_mensagem_pck.get_texto(796831), '@turno', obter_traducao_macro_pront('@turno',869)) ||CHR(10)||
     replace(wheb_mensagem_pck.get_texto(796832), '@prim_hora_dia', obter_traducao_macro_pront('@prim_hora_dia',869));

RETURN ds_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_macro_resumo_sms () FROM PUBLIC;
