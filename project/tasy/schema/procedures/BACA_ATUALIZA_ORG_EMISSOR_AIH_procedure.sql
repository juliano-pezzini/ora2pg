-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_atualiza_org_emissor_aih ( nr_seq_protocolo_p bigint) AS $body$
DECLARE


nr_aih_w		bigint;
nr_sequencia_w		bigint;
nr_atendimento_w	bigint;
cd_pessoa_fisica_w	varchar(10);
cd_estabelecimento_w	smallint;
cd_orgao_emissor_aih_w	varchar(10);
cd_municipio_ibge_w	varchar(6);

C01 CURSOR FOR
	SELECT	b.nr_aih,
		b.nr_sequencia,
		b.nr_atendimento
	from	sus_aih_unif	b,
		conta_paciente	a
	where	a.nr_interno_conta	= b.nr_interno_conta
	and	a.nr_seq_protocolo	= nr_seq_protocolo_p
	order by nr_aih;


BEGIN

open C01;
loop
fetch C01 into
	nr_aih_w,
	nr_sequencia_w,
	nr_atendimento_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	select	cd_pessoa_fisica,
		cd_estabelecimento
	into STRICT	cd_pessoa_fisica_w,
		cd_estabelecimento_w
	from	atendimento_paciente
	where	nr_atendimento	= nr_atendimento_w;

	select	cd_orgao_emissor_aih
	into STRICT	cd_orgao_emissor_aih_w
	from	sus_parametros_aih
	where	cd_estabelecimento	= cd_estabelecimento_w;

	if (cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '') then
		begin
		select	coalesce(max(cd_municipio_ibge),'0')
		into STRICT	cd_municipio_ibge_w
		from	compl_pessoa_fisica
		where	ie_tipo_complemento	= 1
		and	cd_pessoa_fisica	= cd_pessoa_fisica_w;

		if (cd_municipio_ibge_w IS NOT NULL AND cd_municipio_ibge_w::text <> '') and (cd_municipio_ibge_w <> '0') then
			begin
			select	coalesce(cd_orgao_emissor,cd_orgao_emissor_aih_w)
			into STRICT	cd_orgao_emissor_aih_w
			from	sus_municipio
			where	cd_municipio_ibge	= cd_municipio_ibge_w;
			exception
				when others then
				cd_orgao_emissor_aih_w	:= cd_orgao_emissor_aih_w;
			end;
		end if;
		end;
	end if;

	update	sus_aih_unif
	set	cd_orgao_emissor_aih	= cd_orgao_emissor_aih_w
	where	nr_aih			= nr_aih_w
	and	nr_sequencia		= nr_sequencia_w;
	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_atualiza_org_emissor_aih ( nr_seq_protocolo_p bigint) FROM PUBLIC;

