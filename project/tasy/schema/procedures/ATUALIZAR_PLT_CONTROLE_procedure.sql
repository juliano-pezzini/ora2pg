-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



--
-- dblink wrapper to call function atualizar_plt_controle as an autonomous transaction
--
CREATE EXTENSION IF NOT EXISTS dblink;

CREATE OR REPLACE PROCEDURE atualizar_plt_controle ( nm_usuario_p text, nr_atendimento_p bigint, cd_pessoa_fisica_p text, ie_tipo_item_p text, ie_atualizar_p text, nr_prescricao_p bigint) AS $body$
DECLARE
	-- Change this to reflect the dblink connection string
	v_conn_str  text := format('port=%s dbname=%s user=%s', current_setting('port'), current_database(), current_user);
	v_query     text;

BEGIN
	v_query := 'CALL atualizar_plt_controle_atx ( ' || quote_nullable(nm_usuario_p) || ',' || quote_nullable(nr_atendimento_p) || ',' || quote_nullable(cd_pessoa_fisica_p) || ',' || quote_nullable(ie_tipo_item_p) || ',' || quote_nullable(ie_atualizar_p) || ',' || quote_nullable(nr_prescricao_p) || ' )';
	PERFORM * FROM dblink(v_conn_str, v_query) AS p (ret boolean);

END;
$body$ LANGUAGE plpgsql SECURITY DEFINER;




CREATE OR REPLACE PROCEDURE atualizar_plt_controle_atx ( nm_usuario_p text, nr_atendimento_p bigint, cd_pessoa_fisica_p text, ie_tipo_item_p text, ie_atualizar_p text, nr_prescricao_p bigint) AS $body$
DECLARE


nr_atendimento_w		bigint;
cd_pessoa_fisica_w		varchar(15);
BEGIN

if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') then
	begin
		select	nr_atendimento,
				cd_pessoa_fisica
		into STRICT	nr_atendimento_w,
				cd_pessoa_fisica_w
		from	prescr_medica
		where	nr_prescricao	= nr_prescricao_p;
	exception
	when others then
		nr_atendimento_w := nr_atendimento_p;
		cd_pessoa_fisica_w := cd_pessoa_fisica_p;
	end;
else
	nr_atendimento_w	:= nr_atendimento_p;
	cd_pessoa_fisica_w	:= cd_pessoa_fisica_p;

end if;

if (ie_tipo_item_p	= 'M') then
	update	plt_controle
	set	ie_atualizar_medic	= ie_atualizar_p,
		dt_atualizacao		= clock_timestamp()
	where	cd_pessoa_fisica	= cd_pessoa_fisica_w
	and	nr_atendimento		= coalesce(nr_atendimento_w,nr_atendimento)
	and	((nm_usuario		= nm_usuario_p) or (coalesce(nm_usuario_p::text, '') = ''));
elsif (ie_tipo_item_p	= 'MAT') then
	update	plt_controle
	set	ie_atualizar_material	= ie_atualizar_p,
		dt_atualizacao		= clock_timestamp()
	where	cd_pessoa_fisica	= cd_pessoa_fisica_w
	and	nr_atendimento		= coalesce(nr_atendimento_w,nr_atendimento)
	and	((nm_usuario		= nm_usuario_p) or (coalesce(nm_usuario_p::text, '') = ''));
elsif (ie_tipo_item_p	= 'CCG') then
	update	plt_controle
	set	ie_atualizar_ccg	= ie_atualizar_p,
		dt_atualizacao		= clock_timestamp()
	where	cd_pessoa_fisica	= cd_pessoa_fisica_w
	and	nr_atendimento		= coalesce(nr_atendimento_w,nr_atendimento)
	and	((nm_usuario		= nm_usuario_p) or (coalesce(nm_usuario_p::text, '') = ''));
elsif (ie_tipo_item_p	= 'CIG') then
	update	plt_controle
	set	ie_atualizar_cig	= ie_atualizar_p,
		dt_atualizacao		= clock_timestamp()
	where	cd_pessoa_fisica	= cd_pessoa_fisica_w
	and	nr_atendimento		= coalesce(nr_atendimento_w,nr_atendimento)
	and	((nm_usuario		= nm_usuario_p) or (coalesce(nm_usuario_p::text, '') = ''));
elsif (ie_tipo_item_p	= 'DIA') then
	update	plt_controle
	set	ie_atualizar_dialise	= ie_atualizar_p,
		dt_atualizacao		= clock_timestamp()
	where	cd_pessoa_fisica	= cd_pessoa_fisica_w
	and	nr_atendimento		= coalesce(nr_atendimento_w,nr_atendimento)
	and	((nm_usuario		= nm_usuario_p) or (coalesce(nm_usuario_p::text, '') = ''));
elsif (ie_tipo_item_p	= 'D') then
	update	plt_controle
	set	ie_atualizar_dieta	= ie_atualizar_p,
		dt_atualizacao		= clock_timestamp()
	where	cd_pessoa_fisica	= cd_pessoa_fisica_w
	and	nr_atendimento		= coalesce(nr_atendimento_w,nr_atendimento)
	and	((nm_usuario		= nm_usuario_p) or (coalesce(nm_usuario_p::text, '') = ''));
elsif (ie_tipo_item_p	= 'G') then
	update	plt_controle
	set	ie_atualizar_gas	= ie_atualizar_p,
		dt_atualizacao		= clock_timestamp()
	where	cd_pessoa_fisica	= cd_pessoa_fisica_w
	and	nr_atendimento		= coalesce(nr_atendimento_w,nr_atendimento)
	and	((nm_usuario		= nm_usuario_p) or (coalesce(nm_usuario_p::text, '') = ''));
elsif (ie_tipo_item_p	= 'HM') then
	update	plt_controle
	set	ie_atualizar_hemoterap	= ie_atualizar_p,
		dt_atualizacao		= clock_timestamp()
	where	cd_pessoa_fisica	= cd_pessoa_fisica_w
	and	nr_atendimento		= coalesce(nr_atendimento_w,nr_atendimento)
	and	((nm_usuario		= nm_usuario_p) or (coalesce(nm_usuario_p::text, '') = ''));
elsif (ie_tipo_item_p	= 'IVC') then
	update	plt_controle
	set	ie_atualizar_ivc	= ie_atualizar_p,
		dt_atualizacao		= clock_timestamp()
	where	cd_pessoa_fisica	= cd_pessoa_fisica_w
	and	nr_atendimento		= coalesce(nr_atendimento_w,nr_atendimento)
	and	((nm_usuario		= nm_usuario_p) or (coalesce(nm_usuario_p::text, '') = ''));
elsif (ie_tipo_item_p	= 'J') then
	update	plt_controle
	set	ie_atualizar_jejum	= ie_atualizar_p,
		dt_atualizacao		= clock_timestamp()
	where	cd_pessoa_fisica	= cd_pessoa_fisica_w
	and	nr_atendimento		= coalesce(nr_atendimento_w,nr_atendimento)
	and	((nm_usuario		= nm_usuario_p) or (coalesce(nm_usuario_p::text, '') = ''));
elsif (ie_tipo_item_p	= 'L') then
	update	plt_controle
	set	ie_atualizar_lab	= ie_atualizar_p,
		dt_atualizacao		= clock_timestamp()
	where	cd_pessoa_fisica	= cd_pessoa_fisica_w
	and	nr_atendimento		= coalesce(nr_atendimento_w,nr_atendimento)
	and	((nm_usuario		= nm_usuario_p) or (coalesce(nm_usuario_p::text, '') = ''));
elsif (ie_tipo_item_p	= 'LD') then
	update	plt_controle
	set	ie_atualizar_leite	= ie_atualizar_p,
		dt_atualizacao		= clock_timestamp()
	where	cd_pessoa_fisica	= cd_pessoa_fisica_w
	and	nr_atendimento		= coalesce(nr_atendimento_w,nr_atendimento)
	and	((nm_usuario		= nm_usuario_p) or (coalesce(nm_usuario_p::text, '') = ''));
elsif (ie_tipo_item_p	= 'NPA') then
	update	plt_controle
	set	ie_atualizar_npt_adulta	= ie_atualizar_p,
		dt_atualizacao		= clock_timestamp()
	where	cd_pessoa_fisica	= cd_pessoa_fisica_w
	and	nr_atendimento		= coalesce(nr_atendimento_w,nr_atendimento)
	and	((nm_usuario		= nm_usuario_p) or (coalesce(nm_usuario_p::text, '') = ''));
elsif (ie_tipo_item_p	= 'NPN') then
	update	plt_controle
	set	ie_atualizar_npt_neo	= ie_atualizar_p,
		dt_atualizacao		= clock_timestamp()
	where	cd_pessoa_fisica	= cd_pessoa_fisica_w
	and	nr_atendimento		= coalesce(nr_atendimento_w,nr_atendimento)
	and	((nm_usuario		= nm_usuario_p) or (coalesce(nm_usuario_p::text, '') = ''));
elsif (ie_tipo_item_p	= 'NPP') then
	update	plt_controle
	set	ie_atualizar_npt_ped	= ie_atualizar_p,
		dt_atualizacao		= clock_timestamp()
	where	cd_pessoa_fisica	= cd_pessoa_fisica_w
	and	nr_atendimento		= coalesce(nr_atendimento_w,nr_atendimento)
	and	((nm_usuario		= nm_usuario_p) or (coalesce(nm_usuario_p::text, '') = ''));
elsif (ie_tipo_item_p	= 'P') then
	update	plt_controle
	set	ie_atualizar_proced	= ie_atualizar_p,
		dt_atualizacao		= clock_timestamp()
	where	cd_pessoa_fisica	= cd_pessoa_fisica_w
	and	nr_atendimento		= coalesce(nr_atendimento_w,nr_atendimento)
	and	((nm_usuario		= nm_usuario_p) or (coalesce(nm_usuario_p::text, '') = ''));
elsif (ie_tipo_item_p	= 'R') then
	update	plt_controle
	set	ie_atualizar_rec	= ie_atualizar_p,
		dt_atualizacao		= clock_timestamp()
	where	cd_pessoa_fisica	= cd_pessoa_fisica_w
	and	nr_atendimento		= coalesce(nr_atendimento_w,nr_atendimento)
	and	((nm_usuario		= nm_usuario_p) or (coalesce(nm_usuario_p::text, '') = ''));
elsif (ie_tipo_item_p	= 'SNE') then
	update	plt_controle
	set	ie_atualizar_sne	= ie_atualizar_p,
		dt_atualizacao		= clock_timestamp()
	where	cd_pessoa_fisica	= cd_pessoa_fisica_w
	and	nr_atendimento		= coalesce(nr_atendimento_w,nr_atendimento)
	and	((nm_usuario		= nm_usuario_p) or (coalesce(nm_usuario_p::text, '') = ''));
elsif (ie_tipo_item_p	= 'SOL') then
	update	plt_controle
	set	ie_atualizar_solucao	= ie_atualizar_p,
		dt_atualizacao		= clock_timestamp()
	where	cd_pessoa_fisica	= cd_pessoa_fisica_w
	and	nr_atendimento		= coalesce(nr_atendimento_w,nr_atendimento)
	and	((nm_usuario		= nm_usuario_p) or (coalesce(nm_usuario_p::text, '') = ''));
elsif (ie_tipo_item_p	= 'S') then
	update	plt_controle
	set	ie_atualizar_supl	= ie_atualizar_p,
		dt_atualizacao		= clock_timestamp()
	where	cd_pessoa_fisica	= cd_pessoa_fisica_w
	and	nr_atendimento		= coalesce(nr_atendimento_w,nr_atendimento)
	and	nm_usuario		= nm_usuario_p;
elsif (ie_tipo_item_p	= 'TODOS') then
	update	plt_controle
	set	ie_atualizar_dieta     	= ie_atualizar_p,
		ie_atualizar_jejum     	= ie_atualizar_p,
		ie_atualizar_supl      	= ie_atualizar_p,
		ie_atualizar_sne       	= ie_atualizar_p,
		ie_atualizar_npt_adulta	= ie_atualizar_p,
		ie_atualizar_npt_neo   	= ie_atualizar_p,
		ie_atualizar_npt_ped   	= ie_atualizar_p,
		ie_atualizar_leite     	= ie_atualizar_p,
		ie_atualizar_solucao   	= ie_atualizar_p,
		ie_atualizar_medic     	= ie_atualizar_p,
		ie_atualizar_material  	= ie_atualizar_p,
		ie_atualizar_proced    	= ie_atualizar_p,
		ie_atualizar_lab       	= ie_atualizar_p,
		ie_atualizar_ccg       	= ie_atualizar_p,
		ie_atualizar_cig       	= ie_atualizar_p,
		ie_atualizar_ivc       	= ie_atualizar_p,
		ie_atualizar_gas       	= ie_atualizar_p,
		ie_atualizar_hemoterap 	= ie_atualizar_p,
		ie_atualizar_rec       	= ie_atualizar_p,
		ie_atualizar_dialise   	= ie_atualizar_p,
		dt_atualizacao		= clock_timestamp()
	where	cd_pessoa_fisica	= cd_pessoa_fisica_w
	and	nr_atendimento		= coalesce(nr_atendimento_w,nr_atendimento)
	and	((nm_usuario		= nm_usuario_p) or (coalesce(nm_usuario_p::text, '') = ''));
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_plt_controle ( nm_usuario_p text, nr_atendimento_p bigint, cd_pessoa_fisica_p text, ie_tipo_item_p text, ie_atualizar_p text, nr_prescricao_p bigint) FROM PUBLIC; -- REVOKE ALL ON PROCEDURE atualizar_plt_controle_atx ( nm_usuario_p text, nr_atendimento_p bigint, cd_pessoa_fisica_p text, ie_tipo_item_p text, ie_atualizar_p text, nr_prescricao_p bigint) FROM PUBLIC;

