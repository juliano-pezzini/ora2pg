-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION hdp_obter_tipo_percentual ( nr_seq_item_p bigint) RETURNS bigint AS $body$
DECLARE


nr_seq_ajuste_proc_w		bigint	:= 0;
ie_tipo_percentual_w		smallint	:= 0;
tx_ajuste_w			double precision	:= 0;
cd_procedimento_w		bigint	:= 0;
ie_spect_w			varchar(1);


BEGIN

select 	coalesce(max(nr_seq_ajuste_proc),0),
	coalesce(max(cd_procedimento),0),
	coalesce(max(ie_spect),'N')
into STRICT	nr_seq_ajuste_proc_w,
	cd_procedimento_w,
	ie_spect_w
from 	procedimento_paciente
where 	nr_sequencia = nr_seq_item_p;

if (nr_seq_ajuste_proc_w > 0) then

	select 	coalesce(max(tx_ajuste),0)
	into STRICT	tx_ajuste_w
	from 	regra_ajuste_proc
	where 	nr_sequencia = nr_seq_ajuste_proc_w;

	if (tx_ajuste_W > 1) then

		tx_ajuste_w:= tx_ajuste_w * 100 - 100;

		if (tx_ajuste_w = 20) then
			ie_tipo_percentual_w:= 2;
		elsif (tx_ajuste_w = 40) then
			ie_tipo_percentual_w:= 4;
		elsif (tx_ajuste_w = 100) then
			ie_tipo_percentual_w:= 5;
		elsif (tx_ajuste_w = 50) then
			ie_tipo_percentual_w:= 1;
		end if;

		if (cd_procedimento_w in (33010218, 33010226 , 33010234)) then
			ie_tipo_percentual_w:= 3;
		end if;

	end if;
end if;

--Solicitado na OS 776855 em 23/09/2014
if (ie_spect_w = 'S') then
	ie_tipo_percentual_w	:= 1;
end if;

return ie_tipo_percentual_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION hdp_obter_tipo_percentual ( nr_seq_item_p bigint) FROM PUBLIC;
