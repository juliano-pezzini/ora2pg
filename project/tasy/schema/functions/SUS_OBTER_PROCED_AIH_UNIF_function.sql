-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



--
-- dblink wrapper to call function sus_obter_proced_aih_unif as an autonomous transaction
--
CREATE EXTENSION IF NOT EXISTS dblink;

CREATE OR REPLACE FUNCTION sus_obter_proced_aih_unif ( nr_interno_conta_p bigint, ie_tipo_proc_aih_p bigint, ie_retorno_p text) RETURNS varchar AS $body$
DECLARE
	-- Change this to reflect the dblink connection string
	v_conn_str  text := format('port=%s dbname=%s user=%s', current_setting('port'), current_database(), current_user);
	v_query     text;

	v_ret	varchar;
BEGIN
	v_query := 'SELECT * FROM sus_obter_proced_aih_unif_atx ( ' || quote_nullable(nr_interno_conta_p) || ',' || quote_nullable(ie_tipo_proc_aih_p) || ',' || quote_nullable(ie_retorno_p) || ' )';
	SELECT * INTO v_ret FROM dblink(v_conn_str, v_query) AS p (ret varchar);
	RETURN v_ret;

END;
$body$ LANGUAGE plpgsql SECURITY DEFINER;




CREATE OR REPLACE FUNCTION sus_obter_proced_aih_unif_atx ( nr_interno_conta_p bigint, ie_tipo_proc_aih_p bigint, ie_retorno_p text) RETURNS varchar AS $body$
DECLARE


/* ie_tipo_proc_aih_p
	1 - Solicitado
	2 - Realizado
*/
/* ie_retorno_p
	C - Código
	D - Descrição
*/
nr_aih_w			bigint;
nr_seq_aih_w			bigint;
cd_procedimento_solic_w		bigint;
cd_procedimento_real_w		bigint;
cd_procedimento_w		bigint;
ds_retorno_w			varchar(255);
cd_estab_usuario_w		estabelecimento.cd_estabelecimento%type;
nm_usuario_w			usuario.nm_usuario%type;
ie_vincular_laudos_aih_w	varchar(15) := 'N';
nr_seq_interno_w		sus_laudo_paciente.nr_seq_interno%type;
BEGIN

begin
select	nr_aih,
	nr_sequencia
into STRICT	nr_aih_w,
	nr_seq_aih_w
from	sus_aih_unif
where	nr_interno_conta	= nr_interno_conta_p;
exception
	when others then
	nr_aih_w	:= 0;
	nr_seq_aih_w	:= 0;
end;

if (nr_aih_w	> 0) then
	select	cd_procedimento_solic,
		cd_procedimento_real
	into STRICT	cd_procedimento_solic_w,
		cd_procedimento_real_w
	from	sus_aih_unif
	where	nr_aih		= nr_aih_w
	and	nr_sequencia	= nr_seq_aih_w;
else
	begin
	cd_estab_usuario_w		:= coalesce(wheb_usuario_pck.get_cd_estabelecimento,0);
	nm_usuario_w			:= coalesce(wheb_usuario_pck.get_nm_usuario,'');
	ie_vincular_laudos_aih_w 	:= coalesce(obter_valor_param_usuario(1123,180,obter_perfil_ativo, nm_usuario_w, cd_estab_usuario_w),'N');

	if (ie_vincular_laudos_aih_w = 'S') then
		begin

		select	coalesce(max(x.nr_seq_interno),0)
		into STRICT	nr_seq_interno_w
		from	sus_laudo_paciente x
		where	x.nr_interno_conta	= nr_interno_conta_p
		and	x.ie_classificacao 	= 1
		and	x.ie_tipo_laudo_sus 	= 1;

		if (nr_seq_interno_w = 0) then
			begin
			select	coalesce(max(x.nr_seq_interno),0)
			into STRICT	nr_seq_interno_w
			from	sus_laudo_paciente x
			where	x.nr_interno_conta	= nr_interno_conta_p
			and	x.ie_classificacao 	= 1
			and	x.ie_tipo_laudo_sus 	= 0;
			end;
		end if;

		if (coalesce(nr_seq_interno_w,0) > 0) then
			begin

			begin
			select	cd_procedimento_solic,
				cd_procedimento_solic
			into STRICT	cd_procedimento_solic_w,
				cd_procedimento_real_w
			from	sus_laudo_paciente
			where	nr_seq_interno = nr_seq_interno_w;
			exception
			when others then
				cd_procedimento_solic_w	:= null;
				cd_procedimento_real_w	:= null;
			end;

			end;
		end if;
		end;
	end if;
	end;
end if;

if (ie_tipo_proc_aih_p	= 1) then
	cd_procedimento_w	:= cd_procedimento_solic_w;
elsif (ie_tipo_proc_aih_p	= 2) then
	cd_procedimento_w	:= cd_procedimento_real_w;
end if;

if (ie_retorno_p	= 'C') then
	ds_retorno_w	:= cd_procedimento_w;
elsif (ie_retorno_p	= 'D') then
	ds_retorno_w	:= substr(obter_descricao_procedimento(cd_procedimento_w, 7),1,255);
end if;

return	ds_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sus_obter_proced_aih_unif ( nr_interno_conta_p bigint, ie_tipo_proc_aih_p bigint, ie_retorno_p text) FROM PUBLIC; -- REVOKE ALL ON FUNCTION sus_obter_proced_aih_unif_atx ( nr_interno_conta_p bigint, ie_tipo_proc_aih_p bigint, ie_retorno_p text) FROM PUBLIC;
