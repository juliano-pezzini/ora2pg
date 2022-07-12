-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION rxt_obter_autorizacao_proc (nr_seq_tipo_tratamento_p bigint, nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


nr_seq_proc_interno_w	bigint;
cd_procedimento_w	bigint;
ie_origem_proced_w	bigint;
nr_seq_trat_proced_w	bigint;
ie_autorizado_w		varchar(1);
nr_seq_estagio_w	bigint;
ie_autor_interno_w	varchar(2);


BEGIN

if	((coalesce(nr_seq_tipo_tratamento_p,0) > 0) and (coalesce(nr_atendimento_p,0) > 0)) then

	select	coalesce(max(nr_sequencia),0)
	into STRICT	nr_seq_trat_proced_w
	from	rxt_tipo_trat_proced
	where	nr_seq_tipo = nr_seq_tipo_tratamento_p;

	if (nr_seq_trat_proced_w > 0) then

		select	coalesce(max(nr_seq_proc_interno),0)
		into STRICT	nr_seq_proc_interno_w
		from	rxt_tipo_trat_proced
		where	nr_sequencia = nr_seq_trat_proced_w;

		if (nr_seq_proc_interno_w > 0) then

			select	coalesce(max(cd_procedimento),0)
			into STRICT	cd_procedimento_w
			from 	proc_interno
			where 	nr_sequencia = nr_seq_proc_interno_w;

			if (cd_procedimento_w > 0) then

				select	coalesce(max(nr_seq_estagio),0)
				into STRICT	nr_seq_estagio_w
				from	autorizacao_convenio
				where	nr_atendimento = nr_atendimento_p
				and	cd_procedimento_principal = cd_procedimento_w;

				if (nr_seq_estagio_w > 0) then

					select	ie_interno
					into STRICT	ie_autor_interno_w
					from	estagio_autorizacao
					where	nr_sequencia = nr_seq_estagio_w
					and	OBTER_EMPRESA_ESTAB(wheb_usuario_pck.get_cd_estabelecimento) = cd_empresa;

					if (ie_autor_interno_w IS NOT NULL AND ie_autor_interno_w::text <> '') then

						if (ie_autor_interno_w = '10') then
							ie_autorizado_w := 'S';
						else
							ie_autorizado_w := 'N';
						end if;
					end if;
				end if;

			end if;
		end if;
	end if;
end if;


return	ie_autorizado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION rxt_obter_autorizacao_proc (nr_seq_tipo_tratamento_p bigint, nr_atendimento_p bigint) FROM PUBLIC;
