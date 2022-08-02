-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sus_insere_bpa_protocolo ( nr_interno_conta_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, nr_seq_protocolo_p bigint) AS $body$
DECLARE

 
 
cd_convenio_w		integer;
ie_tipo_protocolo_w	smallint;
nr_seq_protocolo_w	bigint;
nr_protocolo_w		varchar(40);


BEGIN 
 
/* Obter dados da conta */
 
select	cd_convenio_parametro 
into STRICT	cd_convenio_w 
from	conta_paciente 
where	nr_interno_conta	= nr_interno_conta_p;
 
if (nr_seq_protocolo_p	> 0) then 
	nr_seq_protocolo_w	:= nr_seq_protocolo_p; /* Caso houver recebe o ultimo protocolo que teve conta inserida*/
else 
	/* Buscar o tipo de protocolo para BPA */
 
	select	coalesce(max(ie_tipo_protocolo_bpa),20) 
	into STRICT	ie_tipo_protocolo_w 
	from	parametro_faturamento 
	where	cd_estabelecimento	= cd_estabelecimento_p;
 
	/* Obter o protocolo */
 
	select	coalesce(max(nr_seq_protocolo),0) 
	into STRICT	nr_seq_protocolo_w 
	from	protocolo_convenio 
	where	cd_convenio		= cd_convenio_w 
	and	ie_tipo_protocolo	= ie_tipo_protocolo_w 
	and	ie_status_protocolo	= 1;
end if;
 
select	coalesce(max(nr_protocolo),'') 
into STRICT	nr_protocolo_w 
from	protocolo_convenio 
where	nr_seq_protocolo	= nr_seq_protocolo_w;
 
update	conta_paciente 
set	nr_seq_protocolo 	= nr_seq_protocolo_w, 
	nm_usuario		= nm_usuario_p 
where	nr_interno_conta	= nr_interno_conta_p 
and	ie_status_acerto	= 2;
 
commit;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sus_insere_bpa_protocolo ( nr_interno_conta_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, nr_seq_protocolo_p bigint) FROM PUBLIC;

