-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_tipo_proced_preco ( cd_convenio_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_prescricao_p bigint, nr_sequencia_p bigint) RETURNS bigint AS $body$
DECLARE


ie_tipo_w	smallint;


BEGIN
-- 9999 quando não encontrado o o procedimento no tipo
ie_tipo_w := 9999;

--Tipo Pacote
select	CASE WHEN count(*)=0 THEN 9999  ELSE 5 END
into STRICT	ie_tipo_w
from	pacote a
where	cd_convenio 	 = cd_convenio_p
and	cd_proced_pacote = cd_procedimento_p
and	ie_origem_proced = ie_origem_proced_p;

if (ie_tipo_w = 9999) then
	--Tipo Exames laboratoriais
	select	CASE WHEN count(*)=0 THEN 9999  ELSE 6 END
	into STRICT	ie_tipo_w
	from	prescr_procedimento
	where	(nr_seq_exame IS NOT NULL AND nr_seq_exame::text <> '')
	and	cd_procedimento = cd_procedimento_p
	and	ie_origem_proced = ie_origem_proced_p
	and	nr_sequencia = nr_sequencia_p
	and	nr_prescricao = nr_prescricao_p;
end if;

if (ie_tipo_w = 9999) then
	--Tipo Proc Interno
	select	CASE WHEN count(*)=0 THEN 9999  ELSE 4 END
	into STRICT	ie_tipo_w
	from	prescr_procedimento
	where	(nr_seq_proc_interno IS NOT NULL AND nr_seq_proc_interno::text <> '')
	and	cd_procedimento = cd_procedimento_p
	and	ie_origem_proced = ie_origem_proced_p
	and	nr_sequencia = nr_sequencia_p
	and	nr_prescricao = nr_prescricao_p;
end if;

if (ie_tipo_w = 9999) then
	--Tipo Procedimento
	select	CASE WHEN count(*)=0 THEN 9999  ELSE 0 END
	into STRICT	ie_tipo_w
	from	procedimento
	where	cd_procedimento = cd_procedimento_p
	and	ie_origem_proced = ie_origem_proced_p
	and	ie_classificacao = 1;
end if;

if (ie_tipo_w = 9999) then
	--Tipo Serviços/Diárias
	select	CASE WHEN count(*)=0 THEN 9999  ELSE 1 END
	into STRICT	ie_tipo_w
	from	procedimento
	where	cd_procedimento = cd_procedimento_p
	and	ie_origem_proced = ie_origem_proced_p
	and	ie_classificacao in (2,3);
end if;


return	ie_tipo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_tipo_proced_preco ( cd_convenio_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_prescricao_p bigint, nr_sequencia_p bigint) FROM PUBLIC;
