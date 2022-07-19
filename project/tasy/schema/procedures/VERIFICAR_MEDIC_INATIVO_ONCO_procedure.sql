-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE verificar_medic_inativo_onco ( nr_seq_paciente_p bigint, ds_retorno_p INOUT text) AS $body$
DECLARE


cd_protocolo_out_w	varchar(2000) := null;

nr_seq_paciente_w	bigint;
cd_protocolo_w		bigint;
cd_pessoa_fisica_w	varchar(10);
ie_existe_w		char(1);
ds_protocolos_w		varchar(2000) := ',';


c01 CURSOR FOR
	SELECT	nr_seq_paciente,
				cd_protocolo
	from	paciente_setor
	where	cd_pessoa_fisica	= cd_pessoa_fisica_w
	and	nr_seq_paciente		<> nr_seq_paciente_p
	and	((ie_status		= 'I') or (ie_status		= 'F'))
	order by
		dt_protocolo;



BEGIN

select	max(cd_pessoa_fisica)
into STRICT	cd_pessoa_fisica_w
from	paciente_setor
where	nr_seq_paciente	= nr_seq_paciente_p;


open c01;
loop
fetch c01 into
	nr_seq_paciente_W,
	cd_protocolo_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

		select	coalesce(max('S'),'N')
		into STRICT	ie_existe_w
		from	paciente_atendimento a,
			paciente_atend_medic b
		where	a.nr_seq_atendimento	= b.nr_seq_atendimento
		and	trunc(a.dt_prevista)	>= trunc(clock_timestamp())
		and	a.nr_seq_paciente	= nr_seq_paciente_w
		and	b.ie_cancelada		= 'N'
		and	coalesce(b.nr_seq_diluicao::text, '') = '';


		if (ie_existe_w = 'S') and (position(','||cd_protocolo_w||',' in ds_protocolos_w) = 0 )then
			cd_protocolo_out_w :=  '- ' || substr(obter_desc_protocolo(cd_protocolo_w),1,80)  || chr(13) || chr(10) || cd_protocolo_out_w;
			ds_protocolos_w := ds_protocolos_w||','||cd_protocolo_w||',';

		end if;

		end;
end loop;
close C01;


if (cd_protocolo_out_w IS NOT NULL AND cd_protocolo_out_w::text <> '') then
	cd_protocolo_out_w := 	/*'Os protocolos abaixo estão inativos e possuem ciclos gerados:'*/
obter_desc_expressao(782122) || chr(13) || chr(10) || cd_protocolo_out_w;
end if;


ds_retorno_p := cd_protocolo_out_w;


end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE verificar_medic_inativo_onco ( nr_seq_paciente_p bigint, ds_retorno_p INOUT text) FROM PUBLIC;

