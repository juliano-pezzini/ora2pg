-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_cor_protocolo (cd_protocolo_p bigint, nr_seq_protocolo_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_proc_interno_p bigint, nr_seq_exame_p bigint default '') RETURNS varchar AS $body$
DECLARE


ds_descricao_w	varchar(254)	:= '';


BEGIN

if (cd_protocolo_p IS NOT NULL AND cd_protocolo_p::text <> '') and (nr_seq_protocolo_p IS NOT NULL AND nr_seq_protocolo_p::text <> '') and (cd_procedimento_p IS NOT NULL AND cd_procedimento_p::text <> '') and (ie_origem_proced_p IS NOT NULL AND ie_origem_proced_p::text <> '') then

	if (coalesce(nr_seq_proc_interno_p,0) = 0) then
		select	max(a.ds_cor)
		into STRICT	ds_descricao_w
		from	protocolo_medic_proc a
		where	cd_protocolo 	 = cd_protocolo_p
		and	nr_sequencia 	 = nr_seq_protocolo_p
		and	cd_procedimento  = cd_procedimento_p
		and	ie_origem_proced = ie_origem_proced_p;
	else
		select	max(a.ds_cor)
		into STRICT	ds_descricao_w
		from	protocolo_medic_proc a
		where	cd_protocolo 	 	= cd_protocolo_p
		and		nr_sequencia 		 = nr_seq_protocolo_p
		and		((nr_seq_proc_interno	= nr_seq_proc_interno_p) or
				 ((coalesce(nr_seq_proc_interno::text, '') = '') and (nr_seq_exame = nr_seq_exame_p)));
	end if;

	if (coalesce(ds_descricao_w, 'XPTO') = 'XPTO') then
		select	max(a.ds_cor)
		into STRICT	ds_descricao_w
		from	protocolo_medic_proc a
		where	cd_protocolo	= cd_protocolo_p
		and		nr_sequencia	= nr_seq_protocolo_p
		and		coalesce(cd_procedimento::text, '') = ''
		and   	coalesce(nr_seq_proc_interno::text, '') = ''
		and   	nr_seq_exame = nr_seq_exame_p;
	end if;

end if;

return	ds_descricao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_cor_protocolo (cd_protocolo_p bigint, nr_seq_protocolo_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_proc_interno_p bigint, nr_seq_exame_p bigint default '') FROM PUBLIC;

