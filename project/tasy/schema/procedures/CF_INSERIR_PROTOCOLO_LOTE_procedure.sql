-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cf_inserir_protocolo_lote ( nr_seq_protocolo_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
cd_convenio_w			protocolo_convenio.cd_convenio%type;
cd_estabelecimento_w		protocolo_convenio.cd_estabelecimento%type;
dt_mesano_referencia_w		protocolo_convenio.dt_mesano_referencia%type;
ie_tipo_protocolo_w		protocolo_convenio.ie_tipo_protocolo%type;
nr_sequencia_w			lote_protocolo.nr_sequencia%type;
					

BEGIN 
 
begin 
 
	select	cd_convenio, 
		cd_estabelecimento, 
		dt_mesano_referencia, 
		ie_tipo_protocolo 
	into STRICT	cd_convenio_w, 
		cd_estabelecimento_w, 
		dt_mesano_referencia_w, 
		ie_tipo_protocolo_w		 
	from	protocolo_convenio 
	where	nr_seq_protocolo = nr_seq_protocolo_p;
exception 
 when others then 
	cd_convenio_w:=0;	
	cd_estabelecimento_w:=0;	
	ie_tipo_protocolo_w:=0;	
end;
	 
	 
if (cd_convenio_w > 0) and (cd_estabelecimento_w > 0) and (ie_tipo_protocolo_w > 0) and (dt_mesano_referencia_w IS NOT NULL AND dt_mesano_referencia_w::text <> '') then 
	 
	select	max(nr_sequencia)		 
	into STRICT	nr_sequencia_w	 
	from	lote_protocolo 
	where	cd_convenio		= cd_convenio_w 
	and	cd_estabelecimento	= cd_estabelecimento_w 
	and	dt_mesano_referencia	= dt_mesano_referencia_w 
	and	ie_tipo_protocolo	= ie_tipo_protocolo_w 
	and	coalesce(dt_liberacao::text, '') = '';
 
	 
	if (nr_sequencia_w IS NOT NULL AND nr_sequencia_w::text <> '') then 
	 
		update	protocolo_convenio 
		set	nr_seq_lote_protocolo	= nr_sequencia_w 
		where	nr_seq_protocolo	= nr_seq_protocolo_p;
		 
	else	 
		 
		select	nextval('lote_protocolo_seq') 
		into STRICT	nr_sequencia_w 
		;
		 
		insert into lote_protocolo(	cd_convenio, 
							cd_estabelecimento, 
							dt_mesano_referencia, 
							ie_tipo_protocolo, 
							nr_sequencia, 
							nm_lote, 
							dt_atualizacao_nrec, 
							dt_atualizacao, 
							nm_usuario_nrec, 
							nm_usuario) 
		values (	cd_convenio_w, 
							cd_estabelecimento_w, 
							dt_mesano_referencia_w, 
							ie_tipo_protocolo_w, 
							nr_sequencia_w, 
							nr_sequencia_w, 
							clock_timestamp(), 
							clock_timestamp(), 
							nm_usuario_p, 
							nm_usuario_p);
		 
		update	protocolo_convenio 
		set	nr_seq_lote_protocolo	= nr_sequencia_w 
		where	nr_seq_protocolo	= nr_seq_protocolo_p;
	 
	end if;
			   
end if;
	 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cf_inserir_protocolo_lote ( nr_seq_protocolo_p bigint, nm_usuario_p text) FROM PUBLIC;
