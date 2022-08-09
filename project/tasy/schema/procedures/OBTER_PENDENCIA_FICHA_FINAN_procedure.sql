-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_pendencia_ficha_finan ( cd_pessoa_fisica_p text, cd_cgc_p text, dt_referencia_p timestamp, ie_aberto_p text, ie_titulo_receb_p INOUT text, ie_adiantamento_p INOUT text, ie_cheque_p INOUT text, ie_cobranca_p INOUT text, ie_conta_paciente_p INOUT text, ie_titulo_pagar_p INOUT text, ie_adiantamento_pago_p INOUT text, ie_repasse_p INOUT text, ie_recb_cartao_p INOUT text) AS $body$
DECLARE

 
 
qt_registro_w	bigint;
dt_referencia_w	timestamp;


BEGIN 
 
dt_referencia_w		:= fim_dia(dt_referencia_p);
 
ie_titulo_receb_p	:= 'N';
ie_adiantamento_p	:= 'N';
ie_cheque_p 		:= 'N';
ie_cobranca_p		:= 'N';
ie_conta_paciente_p	:= 'N';
ie_titulo_pagar_p	:= 'N';
ie_adiantamento_pago_p	:= 'N';
ie_repasse_p		:= 'N';
ie_recb_cartao_p	:= 'N';
 
select	count(*) 
into STRICT	qt_registro_w 
from	titulo_receber 
where (cd_pessoa_fisica = cd_pessoa_fisica_p or cd_cgc = cd_cgc_p) 
and (obter_saldo_titulo_receber(nr_titulo,dt_referencia_w) > 0 or ie_aberto_p = 'N');
 
if (qt_registro_w > 0) then 
	ie_titulo_receb_p	:= 'S';
end if;
 
select	count(*) 
into STRICT	qt_registro_w 
from	adiantamento 
where (cd_pessoa_fisica = cd_pessoa_fisica_p or cd_cgc = cd_cgc_p) 
and (obter_saldo_adiantamento(nr_adiantamento,dt_referencia_w) > 0 or ie_aberto_p = 'N');
 
if (qt_registro_w > 0) then 
	ie_adiantamento_p	:= 'S';
end if;
 
select	count(*) 
into STRICT	qt_registro_w 
from	cheque_cr 
where (cd_pessoa_fisica = cd_pessoa_fisica_p or cd_cgc = cd_cgc_p) 
and (obter_status_cheque_contabil(nr_seq_cheque,dt_referencia_w) not in (1,3,5,7,10) or ie_aberto_p = 'N');
 
if (qt_registro_w > 0) then 
	ie_cheque_p	:= 'S';
end if;
 
select	sum(qt_registro) 
into STRICT	qt_registro_w 
from ( 
	SELECT	count(*) qt_registro 
	from	titulo_receber b, 
		cobranca a 
	where	a.nr_titulo	= b.nr_titulo 
	and (b.cd_pessoa_fisica = cd_pessoa_fisica_p or b.cd_cgc = cd_cgc_p) 
	and (a.ie_status	<> 'E' or ie_aberto_p = 'N') 
	
union all
 
	SELECT	count(*) qt_registro 
	from	cheque_cr b, 
		cobranca a 
	where	a.nr_seq_cheque	= b.nr_seq_cheque 
	and (b.cd_pessoa_fisica = cd_pessoa_fisica_p or b.cd_cgc = cd_cgc_p) 
	and (a.ie_status 	<> 'E' or ie_aberto_p = 'N') 
	) alias7;
 
if (qt_registro_w > 0) then 
	ie_cobranca_p	:= 'S';
end if;
 
select	count(*) 
into STRICT	qt_registro_w 
from	atendimento_paciente b, 
	conta_paciente a 
where	a.nr_atendimento	= b.nr_atendimento 
and (b.cd_pessoa_fisica	= cd_pessoa_fisica_p	or (substr(obter_pessoa_pagador_atend(a.nr_atendimento),1,14) = cd_pessoa_fisica_p	or 
		substr(Obter_pessoa_Pagador_Atend(a.nr_atendimento),1,14) = cd_cgc_p)) 
and (substr(obter_titulo_conta_protocolo(0, a.nr_interno_conta),1,100) is null or ie_aberto_p = 'N');
 
if (qt_registro_w > 0) then 
	ie_conta_paciente_p	:= 'S';
end if;
 
 
select	count(*) 
into STRICT	qt_registro_w 
from	titulo_pagar 
where (cd_pessoa_fisica = cd_pessoa_fisica_p or cd_cgc = cd_cgc_p) 
and (obter_saldo_titulo_pagar(nr_titulo,dt_referencia_w) > 0 or ie_aberto_p = 'N');
 
if (qt_registro_w > 0) then 
	ie_titulo_pagar_p	:= 'S';
end if;
 
select	count(*) 
into STRICT	qt_registro_w 
from	adiantamento_pago 
where (cd_pessoa_fisica = cd_pessoa_fisica_p or cd_cgc = cd_cgc_p) 
and (obter_saldo_adiant_pago(nr_adiantamento,dt_referencia_w) > 0 or ie_aberto_p = 'N');
 
if (qt_registro_w > 0) then 
	ie_adiantamento_pago_p	:= 'S';
end if;
 
select	count(*) 
into STRICT	qt_registro_w 
from	repasse_terceiro 
where (ie_status = 'A' or ie_aberto_p = 'N') 
and	exists (SELECT 1 
from	terceiro x 
where (x.cd_pessoa_fisica	= cd_pessoa_fisica_p or x.cd_cgc = cd_cgc_p) 
and	x.ie_situacao		= 'A' 
and	coalesce(ie_utilizacao,'A')	in ('A','R'));
 
if (qt_registro_w > 0) then 
	ie_repasse_p	:= 'S';
end if;
 
 
select	count(*) 
into STRICT	qt_registro_w 
from	caixa_receb b, 
	movto_cartao_cr a 
where	a.nr_seq_caixa_rec	= b.nr_sequencia 
and (b.cd_pessoa_fisica = cd_pessoa_fisica_p or b.cd_cgc = cd_cgc_p) 
and   ie_lib_caixa = 'S' 
and (obter_saldo_cartao_cr(a.nr_sequencia,dt_referencia_p) > 0 or ie_aberto_p = 'N');
 
 
if (qt_registro_w > 0) then 
	ie_recb_cartao_p	:= 'S';
end if;
 
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_pendencia_ficha_finan ( cd_pessoa_fisica_p text, cd_cgc_p text, dt_referencia_p timestamp, ie_aberto_p text, ie_titulo_receb_p INOUT text, ie_adiantamento_p INOUT text, ie_cheque_p INOUT text, ie_cobranca_p INOUT text, ie_conta_paciente_p INOUT text, ie_titulo_pagar_p INOUT text, ie_adiantamento_pago_p INOUT text, ie_repasse_p INOUT text, ie_recb_cartao_p INOUT text) FROM PUBLIC;
