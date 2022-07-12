-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_macros_nf_observacao (IE_ORIGEM_NF_P text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(4000);


BEGIN

IF (ie_origem_nf_p = 'C') THEN
	ds_retorno_w := '@nr_interno_conta - '||wheb_mensagem_pck.get_texto(328357)||CHR(10)||
			'@nr_atendimento - '||wheb_mensagem_pck.get_texto(328358)||CHR(10)||
			'@nm_paciente - '||wheb_mensagem_pck.get_texto(328359)||CHR(10)||
			'@nr_cpf - '||wheb_mensagem_pck.get_texto(328360)||CHR(10)||
			'@dt_nascimento - '||wheb_mensagem_pck.get_texto(328361)||CHR(10)||
			'@qt_idade - '||wheb_mensagem_pck.get_texto(328362)||CHR(10)||
			'@medic_resp_atend - '||wheb_mensagem_pck.get_texto(1087847);
END IF;
IF (ie_origem_nf_p = 'P') THEN
	ds_retorno_w := '@nr_seq_protocolo - '||wheb_mensagem_pck.get_texto(328363)||CHR(10)||
			'@nr_protocolo - '||wheb_mensagem_pck.get_texto(328364)||CHR(10)||
			'@nr_doc_convenio - '||wheb_mensagem_pck.get_texto(328366);
END IF;
IF (ie_origem_nf_p = 'L') THEN
	ds_retorno_w := '@nr_seq_lote_protocolo - '||wheb_mensagem_pck.get_texto(328367)||CHR(10)||
			'@nr_protocolos_lote - '||wheb_mensagem_pck.get_texto(328368);
END IF;

RETURN 	ds_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_macros_nf_observacao (IE_ORIGEM_NF_P text) FROM PUBLIC;

