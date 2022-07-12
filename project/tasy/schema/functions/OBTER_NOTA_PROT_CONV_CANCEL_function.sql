-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_nota_prot_conv_cancel ( nr_seq_protocolo_p bigint) RETURNS varchar AS $body$
DECLARE

 
 
nr_nota_w			varchar(255);
ds_nota_w			varchar(4000) := ' ';

 
c01 CURSOR FOR 
	SELECT	nr_nota_fiscal 
	from	nota_fiscal 
	where	nr_seq_protocolo_p <> 0 
	and	nr_seq_protocolo = nr_seq_protocolo_p 
	and	(nr_seq_motivo_cancel IS NOT NULL AND nr_seq_motivo_cancel::text <> '') 
	
union
 
	SELECT	substr(b.nr_nota_fiscal,1,255) 
	from	nota_fiscal b, 
		conta_paciente a 
	where	nr_seq_protocolo_p <> 0 
	and	a.nr_seq_protocolo = nr_seq_protocolo_p 
	and	a.nr_interno_conta = b.nr_interno_conta 
	and	(b.nr_seq_motivo_cancel IS NOT NULL AND b.nr_seq_motivo_cancel::text <> '') 
	
union
 
	select	a.nr_nota_fiscal 
	from	nota_fiscal a, 
		protocolo_convenio b 
	where	a.nr_seq_lote_prot = b.nr_seq_lote_protocolo 
	and	nr_seq_protocolo_p <> 0 
	and	a.nr_seq_protocolo = nr_seq_protocolo_p 
	and	(a.nr_seq_motivo_cancel IS NOT NULL AND a.nr_seq_motivo_cancel::text <> '') 
	order by 1;

 

BEGIN 
open c01;
loop 
fetch c01 into nr_nota_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
	if (length(ds_nota_w) < 3600) then 
		ds_nota_w := substr(ds_nota_w || nr_nota_w ||', ',1,4000);
	end if;
end loop;
close c01;
 
return	substr(ds_nota_w,1,length(ds_nota_w) - 2);
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_nota_prot_conv_cancel ( nr_seq_protocolo_p bigint) FROM PUBLIC;

