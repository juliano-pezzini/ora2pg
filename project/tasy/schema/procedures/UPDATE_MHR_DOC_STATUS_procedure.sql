-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE update_mhr_doc_status ( nm_usuario_p mhr_doc_meta.nm_usuario%TYPE , ie_status_p mhr_doc_meta.ie_status%TYPE , cd_pessoa_fisica_p mhr_doc_meta.cd_pessoa_fisica%TYPE , nr_sequencia_p mhr_doc_meta.nr_sequencia%TYPE , cd_doc_mhr_p mhr_doc_meta.cd_doc_mhr%TYPE default null, cd_doc_tasy_p mhr_doc_meta.cd_doc_tasy%TYPE default null, cd_version_p mhr_doc_meta.cd_version%TYPE default null, cd_hash_p mhr_doc_meta.cd_hash%TYPE default null, ie_valid_hash_p mhr_doc_meta.ie_valid_hash%TYPE default null, ie_cda_package_p mhr_doc_meta.ie_cda_package%TYPE default null, ds_doc_file_path_p mhr_doc_meta.ds_doc_file_path%TYPE default null, ds_organization_p mhr_doc_meta.ds_organization%TYPE default null, ds_organization_type_p mhr_doc_meta.ds_organization_type%TYPE default null, ds_author_p mhr_doc_meta.ds_author%TYPE default null, ds_params_p mhr_doc_meta.ds_params%TYPE default null) AS $body$
DECLARE


ie_status_w					mhr_doc_meta.ie_status%TYPE;
cd_pessoa_fisica_w			mhr_doc_meta.cd_pessoa_fisica%TYPE;
ie_origin_mhr_w				mhr_doc_meta.ie_origin_mhr%TYPE;
ie_upload_w					mhr_doc_meta.ie_upload%TYPE;

cd_doc_mhr_w				mhr_doc_meta.cd_doc_mhr%TYPE;
cd_doc_tasy_w				mhr_doc_meta.cd_doc_tasy%TYPE;
cd_version_w				mhr_doc_meta.cd_version%TYPE;
cd_hash_w					mhr_doc_meta.cd_hash%TYPE;
ie_valid_hash_w				mhr_doc_meta.ie_valid_hash%TYPE;
ie_cda_package_w			mhr_doc_meta.ie_cda_package%TYPE;
ds_doc_file_path_w			mhr_doc_meta.ds_doc_file_path%TYPE;
ds_organization_w			mhr_doc_meta.ds_organization%TYPE;
ds_organization_type_w		mhr_doc_meta.ds_organization_type%TYPE;
ds_author_w					mhr_doc_meta.ds_author%TYPE;
ds_params_w					mhr_doc_meta.ds_params%TYPE;
ie_doc_type_w       		mhr_doc_meta.ie_doc_type%TYPE;
nr_sequencia_del_w  	    mhr_doc_meta.nr_sequencia%type;

c01 CURSOR FOR
    SELECT 	a.nr_sequencia
    from 	  mhr_doc_meta a
    where 	a.ie_doc_type = ie_doc_type_w
    and 	  a.ie_upload = 'N'
    and     a.cd_pessoa_fisica = cd_pessoa_fisica_p
    and		  a.cd_doc_mhr <> cd_doc_mhr_w;


BEGIN

	if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') and (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') and (ie_status_p IS NOT NULL AND ie_status_p::text <> '') then

			select 	ie_status,
					cd_pessoa_fisica,
					ie_origin_mhr,
					ie_upload,
					cd_doc_mhr,
					cd_doc_tasy,
					cd_version,
					cd_hash,
					ie_valid_hash,
					ie_cda_package,
					ds_doc_file_path,
					ds_organization,
					ds_organization_type,
					ds_author,
					ds_params,
					ie_doc_type
			into STRICT 	ie_status_w,
					cd_pessoa_fisica_w,
					ie_origin_mhr_w,
					ie_upload_w,
					cd_doc_mhr_w,
					cd_doc_tasy_w,
					cd_version_w,
					cd_hash_w,
					ie_valid_hash_w,
					ie_cda_package_w,
					ds_doc_file_path_w,
					ds_organization_w,
					ds_organization_type_w,
					ds_author_w,
					ds_params_w,
					ie_doc_type_w
			from 	mhr_doc_meta
			where 	nr_sequencia = nr_sequencia_p;
			
			
			if (cd_doc_mhr_p IS NOT NULL AND cd_doc_mhr_p::text <> '') then
				cd_doc_mhr_w := cd_doc_mhr_p;
			end if;

			if (cd_doc_tasy_p IS NOT NULL AND cd_doc_tasy_p::text <> '') then
				cd_doc_tasy_w := cd_doc_tasy_p;
			end if;

			if (cd_version_p IS NOT NULL AND cd_version_p::text <> '') then
				cd_version_w := cd_version_p;
			end if;

			if (cd_hash_p IS NOT NULL AND cd_hash_p::text <> '') then
				cd_hash_w := cd_hash_p;
			end if;

			if (ie_valid_hash_p IS NOT NULL AND ie_valid_hash_p::text <> '') then
				ie_valid_hash_w := ie_valid_hash_p;
			end if;

			if (ds_doc_file_path_p IS NOT NULL AND ds_doc_file_path_p::text <> '') then
				ds_doc_file_path_w := ds_doc_file_path_p;
			end if;

			if (ie_cda_package_p IS NOT NULL AND ie_cda_package_p::text <> '') then
				ie_cda_package_w := ie_cda_package_p;
			end if;

			if (ds_organization_p IS NOT NULL AND ds_organization_p::text <> '') then
				ds_organization_w := ds_organization_p;
			end if;

			if (ds_organization_type_p IS NOT NULL AND ds_organization_type_p::text <> '') then
				ds_organization_type_w := ds_organization_type_p;
			end if;

			if (ds_author_p IS NOT NULL AND ds_author_p::text <> '') then
				ds_author_w := ds_author_p;
			end if;

			if (ds_params_p IS NOT NULL AND ds_params_p::text <> '') then
				ds_params_w := ds_params_p;
			end if;

				
			UPDATE 	mhr_doc_meta
			SET 	nm_usuario = nm_usuario_p,
					ie_status = ie_status_p,
					dt_atualizacao = clock_timestamp(),
					cd_doc_mhr = cd_doc_mhr_w,
					cd_doc_tasy = cd_doc_tasy_w,
					cd_version = cd_version_w,
					cd_hash = cd_hash_w,
					ie_valid_hash = ie_valid_hash_w,
					ds_doc_file_path = ds_doc_file_path_w,
					ie_cda_package = ie_cda_package_w,
					ds_organization = ds_organization_w,
					ds_organization_type = ds_organization_type_w,
					ds_author = ds_author_w,
					ds_params = ds_params_w
			where 	nr_sequencia = nr_sequencia_p;
			
			COMMIT;

			if ( ie_status_p = 'DN' and ie_doc_type_w in ('MV', 'DRV', 'MDVA', 'MDVP', 'PRV') ) then
				open c01;
					loop
						fetch c01 into nr_sequencia_del_w;
						EXIT WHEN NOT FOUND; /* apply on c01 */
						begin
							delete from mhr_doc_files where nr_seq_mhr_doc_meta = nr_sequencia_del_w;
							delete from mhr_doc_meta where nr_sequencia = nr_sequencia_del_w;
						end;
					end loop;
				close c01;
				commit;
			end if;   		
	end if;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE update_mhr_doc_status ( nm_usuario_p mhr_doc_meta.nm_usuario%TYPE , ie_status_p mhr_doc_meta.ie_status%TYPE , cd_pessoa_fisica_p mhr_doc_meta.cd_pessoa_fisica%TYPE , nr_sequencia_p mhr_doc_meta.nr_sequencia%TYPE , cd_doc_mhr_p mhr_doc_meta.cd_doc_mhr%TYPE default null, cd_doc_tasy_p mhr_doc_meta.cd_doc_tasy%TYPE default null, cd_version_p mhr_doc_meta.cd_version%TYPE default null, cd_hash_p mhr_doc_meta.cd_hash%TYPE default null, ie_valid_hash_p mhr_doc_meta.ie_valid_hash%TYPE default null, ie_cda_package_p mhr_doc_meta.ie_cda_package%TYPE default null, ds_doc_file_path_p mhr_doc_meta.ds_doc_file_path%TYPE default null, ds_organization_p mhr_doc_meta.ds_organization%TYPE default null, ds_organization_type_p mhr_doc_meta.ds_organization_type%TYPE default null, ds_author_p mhr_doc_meta.ds_author%TYPE default null, ds_params_p mhr_doc_meta.ds_params%TYPE default null) FROM PUBLIC;

