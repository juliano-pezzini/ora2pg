-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE mims_imp_mat_pbs_insert (cd_imp_material_p imp_material.cd_material%type, cd_sistema_ant_p imp_material.cd_sistema_ant%type, nr_seq_mims_ver bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


qt_exist_pbs_rec_w		bigint;
qt_changed_price_w		bigint;
qt_exist_mat_pbs_w		bigint;
nr_seq_pbs_price_w		pbs_price.nr_sequencia%type;
nr_seq_indication_w		pbs_indication.nr_sequencia%type;
nr_seq_mat_pbs_w		IMP_MATERIAL_PBS.nr_sequencia%type;
nr_mims_indication_w		pbs_indication.nr_mims_indication%type;
ds_material_packinfo_w  varchar(255);
nr_pbs_code_count_w		bigint := 0;
nr_pbs_match_count_w	bigint := 0;
pbs_price_w                packdat.pbs_price%type;
	
c_pbs_material CURSOR(cd_imp_material_w imp_material.cd_material%type, cd_sistema_ant_w imp_material.cd_sistema_ant%type, nr_seq_mims_ver_w bigint) FOR
	SELECT	b.pbs_code,
		b.pbs,
		b.restcode,
		b.authcode,
		b.sec100code,
		cd_imp_material_w cd_material_tasy,
		cd_sistema_ant_w material_cd_sistema_ant,
		(b.prodcode||'.'||b.formcode||'.'||b.packcode) packdat_cd_sistema_ant,
		(coalesce(b.active,'NA')||'-'||coalesce(b.active_units,'NA')||'-'||coalesce(b.units_per_pack,-1)) packdat_packinfo,
		b.pbs_price
	from packdat b
	where
	substr(cd_sistema_ant_w, 0, instr(cd_sistema_ant_w, '.', -1) - 1 ) = (b.prodcode||'.'||b.formcode)
	and	(b.pbs_code IS NOT NULL AND b.pbs_code::text <> '')
	and b.version = nr_seq_mims_ver_w;
		
BEGIN

	for r_pbs_material in c_pbs_material(cd_imp_material_p, cd_sistema_ant_p, nr_seq_mims_ver) loop
	
	begin
		--- Checking if the PBS is recorded in Tasy
		select	count(*)
		into STRICT	qt_exist_pbs_rec_w
		from	pbs_record
		where	cd_pbs = r_pbs_material.pbs_code;

		if (qt_exist_pbs_rec_w = 0) then
			insert into pbs_record(
				cd_pbs,
				cd_estabelecimento,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				ds_pbs,
				ie_situacao)
			values (r_pbs_material.pbs_code,
				cd_estabelecimento_p,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				r_pbs_material.pbs,
				'A'); -- Active
		end if;
		
		--- Checking if the PBS Price is registered in Tasy
		select	coalesce(max(nr_sequencia),-99)
		into STRICT	nr_seq_pbs_price_w
		from	pbs_price
		where	cd_pbs = r_pbs_material.pbs_code
		and	clock_timestamp() between coalesce(dt_start_validity,clock_timestamp()) and coalesce(dt_end_validity,clock_timestamp());

		if (nr_seq_pbs_price_w > 0) then
			begin
			pbs_price_w := REGEXP_replace(r_pbs_material.pbs_price, '\$|,', '');
			select	count(*)
			into STRICT	qt_changed_price_w
			from	pbs_price
			where	nr_sequencia = nr_seq_pbs_price_w
			and	vl_price = (pbs_price_w)::numeric;

			if (qt_changed_price_w = 0) then
				update	pbs_price
			set		dt_start_validity = coalesce(dt_start_validity,clock_timestamp()),
					dt_end_validity = clock_timestamp(),
					nm_usuario = nm_usuario_p,
					dt_atualizacao = clock_timestamp()
				where	nr_sequencia = 	nr_seq_pbs_price_w;
			end if;

			end;
		end if;

		if	((nr_seq_pbs_price_w = -99) or (qt_changed_price_w = 0)) then
			pbs_price_w := 	REGEXP_replace(r_pbs_material.pbs_price, '\$|,', '');
			insert into pbs_price(
				nr_sequencia,
				cd_estabelecimento,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				cd_pbs,
				dt_start_validity,
				vl_price)
			values (nextval('pbs_price_seq'),
				cd_estabelecimento_p,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				r_pbs_material.pbs_code,
				clock_timestamp(),
				(pbs_price_w)::numeric );
		end if;
		
		  -- link PBS only if the active, active_units, units_per_pack matches
  begin
    select (coalesce(b.active,'NA')||'-'||coalesce(b.active_units,'NA')||'-'||coalesce(b.units_per_pack,-1))
    into STRICT ds_material_packinfo_w
    from packdat b
    where (b.prodcode||'.'||b.formcode||'.'||b.packcode) = r_pbs_material.material_cd_sistema_ant
    and b.version = nr_seq_mims_ver;
  exception
    when no_data_found then 
      ds_material_packinfo_w := 'NO_DATA_FOUND';
    when too_many_rows then
      ds_material_packinfo_w := 'TOO_MANY_ROWS';
    when OTHERS then
      ds_material_packinfo_w := 'NOT_APPLICABLE_FOR_THIS_MIMS_VERSION';
  end;


  if (ds_material_packinfo_w = r_pbs_material.packdat_packinfo) then
  
		--- Checking if the PBS is linked with the medicinte in Tasy (Material Record)
		select	coalesce(max(nr_sequencia),-99)
		into STRICT	nr_seq_mat_pbs_w
		from	IMP_MATERIAL_PBS
		where	cd_material = r_pbs_material.cd_material_tasy
		and	cd_pbs = r_pbs_material.pbs_code
		and	clock_timestamp() between coalesce(dt_start_validity,clock_timestamp()) and coalesce(dt_end_validity,clock_timestamp());

		if (nr_seq_mat_pbs_w > 0) then

			select	max(nr_mims_indication)
			into STRICT	nr_mims_indication_w
			from	IMP_MATERIAL_PBS a,
				pbs_indication b
			where	a.nr_sequencia = nr_seq_mat_pbs_w
			and	a.nr_seq_indication =  b.nr_sequencia;

		end if;

-- The idea is to insert only 1 record if PBS code has multiple pbs indications
-- If only single record exist for PBS record, proceed with previous flow
-- If multiple records exist, check if the material_cd_sistema_ant matches with one of the existing  packdat_cd_sistema_ant.
-- 			if yes, insert only that one matching record and ignore others. 
-- 			if no, insert any one of multiple duplicate records. 
		select count(1) into STRICT nr_pbs_code_count_w
		from packdat
		where version = nr_seq_mims_ver
		and pbs_code = r_pbs_material.pbs_code;

    nr_pbs_match_count_w := 0;

    if ( nr_pbs_code_count_w > 1 ) then
			select count(1)
			into STRICT nr_pbs_match_count_w 
			from packdat
			where version = nr_seq_mims_ver 
			and pbs_code = r_pbs_material.pbs_code
			and prodcode||'.'||formcode||'.'||packcode = r_pbs_material.material_cd_sistema_ant;
		end if;

    if ( (nr_pbs_code_count_w = 1) or (nr_pbs_match_count_w = 1  and r_pbs_material.material_cd_sistema_ant = r_pbs_material.packdat_cd_sistema_ant ) ) then

			if	((nr_seq_mat_pbs_w = -99) or
				((nr_seq_mat_pbs_w > 0) and
				 ((nr_mims_indication_w <> coalesce(r_pbs_material.restcode, nr_mims_indication_w)) or (nr_mims_indication_w <> coalesce(r_pbs_material.authcode, nr_mims_indication_w)) or (nr_mims_indication_w <> coalesce(r_pbs_material.sec100code, nr_mims_indication_w))))) then


				update	IMP_MATERIAL_PBS
				set	dt_start_validity = coalesce(dt_start_validity,clock_timestamp()),
					dt_end_validity = clock_timestamp(),
					nm_usuario = nm_usuario_p,
					dt_atualizacao = clock_timestamp()
				where	nr_sequencia = 	nr_seq_mat_pbs_w;

				select	max(nr_sequencia)
				into STRICT	nr_seq_indication_w
				from	pbs_indication
				where	((nr_mims_indication = r_pbs_material.restcode) or (nr_mims_indication = r_pbs_material.authcode) or (nr_mims_indication = r_pbs_material.sec100code))
				and	ie_situacao = 'A';

				insert into IMP_MATERIAL_PBS(
					nr_sequencia,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					cd_estabelecimento,
					cd_pbs,
					cd_material,
					dt_start_validity,
					nr_seq_indication,
					CD_SISTEMA_ANT,
					NR_SEQ_MIMS_VERSION)
				values (nextval('imp_material_pbs_seq'),
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					cd_estabelecimento_p,
					r_pbs_material.pbs_code,
					r_pbs_material.cd_material_tasy,
					clock_timestamp(),
					nr_seq_indication_w,
					cd_sistema_ant_p,
					nr_seq_mims_ver);
			end if;

      end if;  -- end of condition if ( nr_pbs_code_count_w = 1) then
    if ( nr_seq_mat_pbs_w = -99  and nr_pbs_code_count_w > 1 and nr_pbs_match_count_w = 0) then
			select	max(nr_sequencia)
			into STRICT	nr_seq_indication_w
			from	pbs_indication
			where	((nr_mims_indication = r_pbs_material.restcode) or (nr_mims_indication = r_pbs_material.authcode) or (nr_mims_indication = r_pbs_material.sec100code))
			and	ie_situacao = 'A';

			insert into IMP_MATERIAL_PBS(
				nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				cd_estabelecimento,
				cd_pbs,
				cd_material,
				dt_start_validity,
				nr_seq_indication,
				CD_SISTEMA_ANT,
				NR_SEQ_MIMS_VERSION)
			values (nextval('imp_material_pbs_seq'),
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				cd_estabelecimento_p,
				r_pbs_material.pbs_code,
				r_pbs_material.cd_material_tasy,
				clock_timestamp(),
				nr_seq_indication_w,
				cd_sistema_ant_p,
				nr_seq_mims_ver);

		end if;  -- end of condition nr_seq_mat_pbs_w = -99  and nr_pbs_code_count_w > 1 and nr_pbs_match_count_w = 0
    end if; -- end of ds_material_packinfo_w check
	end;	
	
	end loop; --end of r_pbs_material loop
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE mims_imp_mat_pbs_insert (cd_imp_material_p imp_material.cd_material%type, cd_sistema_ant_p imp_material.cd_sistema_ant%type, nr_seq_mims_ver bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

