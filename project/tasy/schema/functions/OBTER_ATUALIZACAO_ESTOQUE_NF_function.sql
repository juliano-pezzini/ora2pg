-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_atualizacao_estoque_nf ( nr_seq_protocolo_p bigint, ie_opcao_p text) RETURNS timestamp AS $body$
DECLARE

 
 
nr_sequencia_w	bigint;
dt_retorno_w	timestamp;
dt_atual_w	timestamp;

/* ie_opcao_p: 
ME - Menor data 
MA - Maior data 
NR - Data da última NF ( maior sequencia) 
*/
 
 
c01 CURSOR FOR 
	SELECT	nr_sequencia 
	from ( 
		SELECT	nr_sequencia 
		from	nota_fiscal 
		where (nr_seq_protocolo_p <> 0) 
		and	ie_situacao = '1' 
		and (nr_seq_protocolo = nr_seq_protocolo_p) 
		
union
 
		select	b.nr_sequencia 
		from	nota_fiscal b, 
			conta_paciente a 
		where (nr_seq_protocolo_p <> 0) 
		and	a.nr_seq_protocolo = nr_seq_protocolo_p 
		and	a.nr_interno_conta = b.nr_interno_conta 
		and	b.ie_situacao = '1' 
		
union
 
		select	obter_sequencia_nota_fiscal(nr_nota_fiscal) nr_sequencia 
		from	titulo_receber 
		where	nr_seq_protocolo = nr_seq_protocolo_p 
		and 	coalesce(nr_nota_fiscal,'0')	<> '0'	) alias5 
	order by nr_sequencia;


BEGIN 
 
open C01;
loop 
fetch C01 into	 
	nr_sequencia_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	 
	select	max(to_date(obter_dados_nota_fiscal(nr_sequencia_w, 27), 'dd/mm/yyyy hh24:mi:ss')) 
	into STRICT	dt_atual_w 
	;
	 
	if (dt_atual_w IS NOT NULL AND dt_atual_w::text <> '') then 
		if (dt_retorno_w IS NOT NULL AND dt_retorno_w::text <> '') then		 
			if (ie_opcao_p = 'ME') and (dt_atual_w < dt_retorno_W) then 
				dt_retorno_w	:= dt_atual_w;
			end if;	
			 
			if (ie_opcao_p = 'MA') and (dt_atual_w > dt_retorno_W) then 
				dt_retorno_w	:= dt_atual_w;
			end if;
			 
			if (ie_opcao_p = 'NR') then 
				dt_retorno_w	:= dt_atual_w;
			end if;
		else 
			dt_retorno_w	:= dt_atual_w;		
		end if;
	end if;
	 
	end;
end loop;
close C01;
 
return dt_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_atualizacao_estoque_nf ( nr_seq_protocolo_p bigint, ie_opcao_p text) FROM PUBLIC;

