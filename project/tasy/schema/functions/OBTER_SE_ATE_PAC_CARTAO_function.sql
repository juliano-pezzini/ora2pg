-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_ate_pac_cartao ( nr_seq_caixa_rec_p bigint) RETURNS varchar AS $body$
DECLARE

 
nr_atendimento_w	atendimento_paciente.nr_atendimento%type;
nr_cartao_w		movto_cartao_cr.nr_cartao%type;
ie_tipo_cartao_w	movto_cartao_cr.ie_tipo_cartao%type;
nr_seq_bandeira_w	movto_cartao_cr.nr_seq_bandeira%type;
ds_retorno_w		varchar(1) := 'S';	
 
c01 CURSOR FOR 
	SELECT	a.nr_atendimento 
	from	titulo_receber a, 
		titulo_receber_liq b 
	where	b.nr_seq_caixa_rec 	= nr_seq_caixa_rec_p 
	and	a.nr_titulo		= b.nr_titulo 
	and	(a.nr_atendimento IS NOT NULL AND a.nr_atendimento::text <> '') 
	
union
 
	SELECT	c.nr_atendimento 
	from	titulo_receber a, 
		titulo_receber_liq b, 
		conta_paciente c 
	where	b.nr_seq_caixa_rec 	= nr_seq_caixa_rec_p 
	and	a.nr_titulo 		= b.nr_titulo 
	and	a.nr_interno_conta 	= c.nr_interno_conta 
	and	(c.nr_atendimento IS NOT NULL AND c.nr_atendimento::text <> '') 
	
union
 
	select	a.nr_atendimento 
	from	adiantamento a 
	where	a.nr_seq_caixa_rec 	= nr_seq_caixa_rec_p 
	and	(a.nr_atendimento IS NOT NULL AND a.nr_atendimento::text <> '');

c02 CURSOR FOR 
	SELECT	a.nr_cartao, 
		a.ie_tipo_cartao, 
		a.nr_seq_bandeira 
	from	movto_cartao_cr a 
	where	a.nr_seq_caixa_rec	= nr_seq_caixa_rec_p;
	

BEGIN 
 
open c01;
	loop 
	fetch c01 into	 
		nr_atendimento_w;		
	exit when(C01%notfound) or (ds_retorno_w = 'N');
		begin 
		 
		open c02;
			loop 
			fetch c02 into	 
				nr_cartao_w, 
				ie_tipo_cartao_w, 
				nr_seq_bandeira_w;
			exit when(C02%notfound) or (ds_retorno_w = 'N');
				begin 
				 
				select	coalesce(max('S'),'N') 
				into STRICT	ds_retorno_w 
				from	atend_paciente_cartao a 
				where	a.nr_atendimento	= nr_atendimento_w 
				and	a.nr_cartao		= nr_cartao_w 
				and	a.ie_tipo_cartao	= ie_tipo_cartao_w 
				and	a.nr_seq_bandeira	= nr_seq_bandeira_w;
				 
				end;
			end loop;
			close c02;		
		end;
	end loop;
	close c01;
 
return ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_ate_pac_cartao ( nr_seq_caixa_rec_p bigint) FROM PUBLIC;
