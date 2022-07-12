-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_lote_audit (NR_SEQ_LOTE_P bigint, IE_OPCAO_P bigint) RETURNS varchar AS $body$
DECLARE

 
/* ie_opcao_p 
auditori 
1	protocolo 
2	título 
3	tipo protocolo 
recurso de glosas (GRG) 
4	primeira análise 
*/
 
 
nr_titulo_w		varchar(2000);
nr_seq_protocolo_w	bigint;
tipo_protocolo_w	varchar(254);
ds_retorno_w		varchar(4000);

C01 CURSOR FOR 
	SELECT distinct 	 
		d.nr_seq_protocolo, 
		obter_titulo_conta_protocolo(d.nr_seq_protocolo,d.nr_interno_conta), 
		obter_valor_dominio(73,obter_tipo_protocolo(d.nr_seq_protocolo)) 
	from	lote_audit_recurso a, 
		conta_paciente_ret_hist b, 
		conta_paciente_retorno c, 
		conta_paciente d 
	where	nr_seq_lote_p 		<> 0 
	and	a.nr_sequencia		= nr_seq_lote_p 
	and	a.nr_sequencia		= b.nr_seq_lote_recurso 
	and	b.nr_seq_conpaci_ret	= c.nr_sequencia 
	and	c.nr_interno_conta	= d.nr_interno_conta 
	and	ie_opcao_p		in (1,2,3);


BEGIN 
 
open C01;
loop 
fetch C01 into 	 
	nr_seq_protocolo_W, 
	nr_titulo_w, 
	tipo_protocolo_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
 
	if (length(coalesce(ds_retorno_w, '0')) < 3980) then 
 
		if (ds_retorno_w IS NOT NULL AND ds_retorno_w::text <> '') and ((nr_seq_protocolo_W IS NOT NULL AND nr_seq_protocolo_W::text <> '') or (nr_titulo_w IS NOT NULL AND nr_titulo_w::text <> '') or (tipo_protocolo_w IS NOT NULL AND tipo_protocolo_w::text <> '')) then 
			ds_retorno_w	:= ds_retorno_w || ', ';
		end if;
 
		if (ie_opcao_p = 1) then 
			ds_retorno_w	:= ds_retorno_w || nr_seq_protocolo_w;
		elsif (ie_opcao_p = 2) then 
			ds_retorno_w	:= ds_retorno_w	|| nr_titulo_w;
		elsif (ie_opcao_p = 3) then 
			ds_retorno_w	:= ds_retorno_w	|| tipo_protocolo_w;
		end if;
	end if;
 
end loop;
close C01;
 
if (ie_opcao_p	= 4) then 
	select	min(a.nr_sequencia) 
	into STRICT	ds_retorno_w 
	from	lote_audit_hist a 
	where	a.nr_seq_lote_audit	= nr_seq_lote_p;
end if;
 
return	ds_retorno_w;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_lote_audit (NR_SEQ_LOTE_P bigint, IE_OPCAO_P bigint) FROM PUBLIC;
