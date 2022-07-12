-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dado_repasse_propaci ( nr_seq_procedimento_p bigint, nr_seq_terceiro_p bigint, ie_opcao_p bigint) RETURNS varchar AS $body$
DECLARE

 
ds_retorno_w		varchar(20);
nr_seq_retorno_w		bigint;
nr_seq_protocolo_w	bigint;
nr_interno_conta_w	bigint;


BEGIN 
 
if (ie_opcao_p = 0) then 
	select	sum(vl_repasse) 
	into STRICT	ds_retorno_w 
	from procedimento_repasse 
	where nr_seq_procedimento	= nr_seq_procedimento_p 
	 and nr_seq_terceiro		= nr_seq_terceiro_p 
	 and (nr_seq_item_retorno IS NOT NULL AND nr_seq_item_retorno::text <> '') 
	 and coalesce(nr_seq_ret_glosa::text, '') = '';
elsif (ie_opcao_p = 1) then 
	select	sum(vl_repasse) 
	into STRICT	ds_retorno_w 
	from procedimento_repasse 
	where nr_seq_procedimento	= nr_seq_procedimento_p 
	 and nr_seq_terceiro		= nr_seq_terceiro_p 
	 and (nr_seq_ret_glosa IS NOT NULL AND nr_seq_ret_glosa::text <> '');
elsif (ie_opcao_p = 2) then 
	select	min(nr_seq_item_retorno) 
	into STRICT	nr_seq_retorno_w 
	from procedimento_repasse 
	where nr_seq_procedimento	= nr_seq_procedimento_p 
	 and nr_seq_terceiro		= nr_seq_terceiro_p 
	 and (nr_seq_item_retorno IS NOT NULL AND nr_seq_item_retorno::text <> '') 
	 and coalesce(nr_seq_ret_glosa::text, '') = '';
 
	if (nr_seq_retorno_w IS NOT NULL AND nr_seq_retorno_w::text <> '') then 
		select	coalesce(min(dt_fechamento),null) 
		into STRICT	ds_retorno_w 
		from	convenio_retorno b, 
			convenio_retorno_item a 
		where	a.nr_seq_retorno= b.nr_sequencia 
		 and	a.nr_sequencia	= nr_seq_retorno_w;
	end if;
elsif (ie_opcao_p = 3) then 
	select	min(nr_seq_ret_glosa) 
	into STRICT	nr_seq_retorno_w 
	from procedimento_repasse 
	where nr_seq_procedimento	= nr_seq_procedimento_p 
	 and nr_seq_terceiro		= nr_seq_terceiro_p 
	 and (nr_seq_ret_glosa IS NOT NULL AND nr_seq_ret_glosa::text <> '');
 
	if (nr_seq_retorno_w IS NOT NULL AND nr_seq_retorno_w::text <> '') then 
		select	coalesce(min(dt_fechamento),null) 
		into STRICT	ds_retorno_w 
		from	convenio_retorno c, 
			convenio_retorno_item b, 
			convenio_retorno_glosa a 
		where	a.nr_seq_ret_item	= b.nr_sequencia 
		 and	b.nr_seq_retorno	= c.nr_sequencia 
		 and	a.nr_sequencia		= nr_seq_retorno_w;
	end if;
elsif (ie_opcao_p = 4) then /* vl_pendente*/
 
	select	sum(vl_repasse) 
	into STRICT	ds_retorno_w 
	from	procedimento_repasse 
	where	nr_seq_procedimento	= nr_seq_procedimento_p 
	and	nr_seq_terceiro		= nr_seq_terceiro_p 
	and	coalesce(nr_repasse_terceiro::text, '') = '';
elsif (ie_opcao_p = 5) then /* dt_protocolo*/
 
	select	a.nr_interno_conta 
	into STRICT	nr_interno_conta_w 
	from	procedimento_paciente a 
	where	a.nr_sequencia 	= nr_seq_procedimento_p;
 
	select	b.nr_seq_protocolo 
	into STRICT	nr_seq_protocolo_w 
	from	conta_paciente b 
	where	b.nr_interno_conta	= nr_interno_conta_w;
 
	select	a.dt_mesano_referencia 
	into STRICT	ds_retorno_w 
	from	protocolo_convenio a 
	where	a.nr_seq_protocolo	= nr_seq_protocolo_w;
elsif (ie_opcao_p = 6) then /* dt_protocolo*/
 
	select	a.nr_interno_conta 
	into STRICT	nr_interno_conta_w 
	from	procedimento_paciente a 
	where	a.nr_sequencia 	= nr_seq_procedimento_p;
 
	select	max(b.nr_seq_retorno) 
	into STRICT	nr_seq_retorno_w 
	from	convenio_retorno_item b 
	where	b.nr_interno_conta	= nr_interno_conta_w;
 
	select	max(c.dt_fechamento) 
	into STRICT	ds_retorno_w 
	from	convenio_retorno c 
	where	c.nr_sequencia	= nr_seq_retorno_w;
elsif (ie_opcao_p = 7) then	/* repasse do procedimento */
 
	select	sum(vl_repasse) 
	into STRICT	ds_retorno_w 
	from procedimento_repasse 
	where	nr_seq_procedimento	= nr_seq_procedimento_p 
	and	nr_seq_terceiro		= coalesce(nr_seq_terceiro_p,nr_seq_terceiro);
 
end if;
 
return ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dado_repasse_propaci ( nr_seq_procedimento_p bigint, nr_seq_terceiro_p bigint, ie_opcao_p bigint) FROM PUBLIC;
